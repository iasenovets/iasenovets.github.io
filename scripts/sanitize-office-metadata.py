#!/usr/bin/env python3

"""Remove package metadata from OOXML documents without extracting them."""

from __future__ import annotations

import copy
import os
import stat
import sys
import tempfile
import zipfile
from pathlib import Path
from xml.etree import ElementTree


SUPPORTED_SUFFIXES = {".docx", ".pptx", ".xlsx"}
PROPERTY_PARTS = {
    "docprops/app.xml",
    "docprops/core.xml",
    "docprops/custom.xml",
}
FIXED_ZIP_TIMESTAMP = (1980, 1, 1, 0, 0, 0)


def is_thumbnail(name: str) -> bool:
    return name.lower().startswith("docprops/thumbnail.")


def serialize_xml(root: ElementTree.Element) -> bytes:
    return ElementTree.tostring(root, encoding="utf-8", xml_declaration=True)


def empty_property_part(data: bytes) -> bytes:
    root = ElementTree.fromstring(data)
    root[:] = []
    return serialize_xml(root)


def remove_thumbnail_relationships(data: bytes) -> bytes:
    root = ElementTree.fromstring(data)
    for relationship in list(root):
        if is_thumbnail_relationship(relationship):
            root.remove(relationship)
    return serialize_xml(root)


def remove_thumbnail_content_types(data: bytes) -> bytes:
    root = ElementTree.fromstring(data)
    for content_type in list(root):
        if is_thumbnail_content_type(content_type):
            root.remove(content_type)
    return serialize_xml(root)


def is_thumbnail_relationship(relationship: ElementTree.Element) -> bool:
    relationship_type = relationship.attrib.get("Type", "").lower()
    target = relationship.attrib.get("Target", "").replace("\\", "/").lstrip("/").lower()
    return relationship_type.endswith("/thumbnail") or target.startswith("docprops/thumbnail.")


def is_thumbnail_content_type(content_type: ElementTree.Element) -> bool:
    part_name = content_type.attrib.get("PartName", "").lower()
    return part_name.startswith("/docprops/thumbnail.")


def sanitize_part(name: str, data: bytes) -> bytes:
    normalized_name = name.lower()
    if normalized_name in PROPERTY_PARTS:
        return empty_property_part(data)
    if normalized_name == "_rels/.rels":
        return remove_thumbnail_relationships(data)
    if normalized_name == "[content_types].xml":
        return remove_thumbnail_content_types(data)
    return data


def sanitized_info(source_info: zipfile.ZipInfo) -> zipfile.ZipInfo:
    target_info = copy.copy(source_info)
    target_info.date_time = FIXED_ZIP_TIMESTAMP
    target_info.comment = b""
    target_info.extra = b""
    return target_info


def validate_path(path: Path) -> None:
    if path.suffix.lower() not in SUPPORTED_SUFFIXES:
        raise ValueError(f"unsupported Office extension: {path.suffix or '<none>'}")
    if not path.is_file():
        raise FileNotFoundError(path)


def check_document(path: Path) -> None:
    validate_path(path)
    with zipfile.ZipFile(path, "r") as archive:
        corrupt_entry = archive.testzip()
        if corrupt_entry is not None:
            raise zipfile.BadZipFile(f"corrupt entry: {corrupt_entry}")
        if archive.comment:
            raise ValueError("ZIP archive comment remains")

        for info in archive.infolist():
            normalized_name = info.filename.lower()
            if info.date_time != FIXED_ZIP_TIMESTAMP:
                raise ValueError(f"ZIP timestamp remains: {info.filename}")
            if info.comment or info.extra:
                raise ValueError(f"ZIP entry metadata remains: {info.filename}")
            if is_thumbnail(info.filename):
                raise ValueError(f"thumbnail remains: {info.filename}")

            data = archive.read(info)
            if normalized_name in PROPERTY_PARTS and len(ElementTree.fromstring(data)) != 0:
                raise ValueError(f"document properties remain: {info.filename}")
            if normalized_name == "_rels/.rels":
                root = ElementTree.fromstring(data)
                if any(is_thumbnail_relationship(item) for item in root):
                    raise ValueError("thumbnail relationship remains")
            if normalized_name == "[content_types].xml":
                root = ElementTree.fromstring(data)
                if any(is_thumbnail_content_type(item) for item in root):
                    raise ValueError("thumbnail content type remains")


def sanitize_document(path: Path) -> None:
    validate_path(path)

    original_mode = stat.S_IMODE(path.stat().st_mode)
    file_descriptor, temporary_name = tempfile.mkstemp(
        prefix=f".{path.name}.metadata-sanitize.",
        suffix=path.suffix,
        dir=path.parent,
    )
    os.close(file_descriptor)
    temporary_path = Path(temporary_name)

    try:
        with zipfile.ZipFile(path, "r") as source_archive:
            with zipfile.ZipFile(temporary_path, "w") as target_archive:
                target_archive.comment = b""
                for source_info in source_archive.infolist():
                    if is_thumbnail(source_info.filename):
                        continue
                    data = source_archive.read(source_info)
                    target_archive.writestr(
                        sanitized_info(source_info),
                        sanitize_part(source_info.filename, data),
                    )

        with zipfile.ZipFile(temporary_path, "r") as verification_archive:
            corrupt_entry = verification_archive.testzip()
            if corrupt_entry is not None:
                raise zipfile.BadZipFile(f"corrupt entry after sanitizing: {corrupt_entry}")

        os.chmod(temporary_path, original_mode)
        os.replace(temporary_path, path)
    finally:
        temporary_path.unlink(missing_ok=True)


def main(arguments: list[str]) -> int:
    check_only = len(arguments) == 3 and arguments[1] == "--check"
    if len(arguments) == 2:
        path = Path(arguments[1])
    elif check_only:
        path = Path(arguments[2])
    else:
        print(f"Usage: {Path(arguments[0]).name} [--check] FILE", file=sys.stderr)
        return 2

    try:
        if check_only:
            check_document(path)
        else:
            sanitize_document(path)
    except (FileNotFoundError, OSError, ValueError, ElementTree.ParseError, zipfile.BadZipFile) as error:
        print(f"Office metadata sanitizer failed: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
