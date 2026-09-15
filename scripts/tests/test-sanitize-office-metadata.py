#!/usr/bin/env python3

from __future__ import annotations

import os
import shutil
import subprocess
import tempfile
import zipfile
from pathlib import Path
from xml.etree import ElementTree


REPO_ROOT = Path(__file__).resolve().parents[2]
SANITIZER = REPO_ROOT / "scripts" / "sanitize-office-metadata.py"
GIT_SANITIZER = REPO_ROOT / "scripts" / "sanitize-metadata.sh"

CONTENT_TYPES = b"""<?xml version="1.0" encoding="UTF-8"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
  <Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
  <Override PartName="/docProps/custom.xml" ContentType="application/vnd.openxmlformats-officedocument.custom-properties+xml"/>
  <Override PartName="/docProps/thumbnail.jpeg" ContentType="image/jpeg"/>
</Types>
"""

RELATIONSHIPS = b"""<?xml version="1.0" encoding="UTF-8"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/custom-properties" Target="docProps/custom.xml"/>
  <Relationship Id="rId4" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/thumbnail" Target="docProps/thumbnail.jpeg"/>
</Relationships>
"""

CORE_PROPERTIES = b"""<?xml version="1.0" encoding="UTF-8"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/">
  <dc:title>Private title</dc:title>
  <dc:creator>Private author</dc:creator>
  <cp:lastModifiedBy>Private editor</cp:lastModifiedBy>
</cp:coreProperties>
"""

APP_PROPERTIES = b"""<?xml version="1.0" encoding="UTF-8"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
  <Application>Private application</Application>
  <Company>Private company</Company>
</Properties>
"""

CUSTOM_PROPERTIES = b"""<?xml version="1.0" encoding="UTF-8"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/custom-properties">
  <property name="Private custom property"/>
</Properties>
"""

PAYLOAD = b"document payload must remain byte-for-byte unchanged"


def create_fixture(path: Path) -> None:
    with zipfile.ZipFile(path, "w", compression=zipfile.ZIP_DEFLATED) as archive:
        archive.comment = b"Private archive comment"
        archive.writestr("[Content_Types].xml", CONTENT_TYPES)
        archive.writestr("_rels/.rels", RELATIONSHIPS)
        archive.writestr("docProps/core.xml", CORE_PROPERTIES)
        archive.writestr("docProps/app.xml", APP_PROPERTIES)
        archive.writestr("docProps/custom.xml", CUSTOM_PROPERTIES)
        archive.writestr("docProps/thumbnail.jpeg", b"private thumbnail")
        archive.writestr("content/payload.bin", PAYLOAD)


def assert_empty_properties(data: bytes) -> None:
    root = ElementTree.fromstring(data)
    assert len(root) == 0


def assert_sanitized(path: Path) -> None:
    with zipfile.ZipFile(path) as archive:
        assert archive.testzip() is None
        assert archive.comment == b""
        assert all(info.date_time == (1980, 1, 1, 0, 0, 0) for info in archive.infolist())
        assert all(info.comment == b"" and info.extra == b"" for info in archive.infolist())
        assert archive.read("content/payload.bin") == PAYLOAD
        assert_empty_properties(archive.read("docProps/core.xml"))
        assert_empty_properties(archive.read("docProps/app.xml"))
        assert_empty_properties(archive.read("docProps/custom.xml"))
        assert "docProps/thumbnail.jpeg" not in archive.namelist()

        relationships = ElementTree.fromstring(archive.read("_rels/.rels"))
        assert all(
            not relationship.attrib.get("Type", "").endswith("/thumbnail")
            for relationship in relationships
        )

        content_types = ElementTree.fromstring(archive.read("[Content_Types].xml"))
        assert all(
            content_type.attrib.get("PartName") != "/docProps/thumbnail.jpeg"
            for content_type in content_types
        )

        combined_xml = b"".join(
            archive.read(name) for name in archive.namelist() if name.endswith(".xml")
        )
        assert b"Private" not in combined_xml


def assert_git_hook_routes_office_files(temporary_path: Path) -> None:
    repository = temporary_path / "repository"
    scripts = repository / "scripts"
    scripts.mkdir(parents=True)
    shutil.copy2(GIT_SANITIZER, scripts / GIT_SANITIZER.name)
    shutil.copy2(SANITIZER, scripts / SANITIZER.name)

    subprocess.run(["git", "init", "-q", str(repository)], check=True)
    fixture = repository / "fixture.pptx"
    create_fixture(fixture)
    subprocess.run(["git", "add", fixture.name], cwd=repository, check=True)

    cache = repository / ".git" / "metadata-tools" / "Image-ExifTool-13.59"
    cache.mkdir(parents=True)
    fake_exiftool = cache / "exiftool"
    fake_exiftool.write_text('die "ExifTool must not write Office files\\n";\n')

    environment = os.environ.copy()
    environment["METADATA_SANITIZER_ENGINE"] = "exiftool"
    environment["METADATA_SANITIZER_CACHE_DIR"] = str(cache.parent)
    subprocess.run(
        [str(scripts / GIT_SANITIZER.name), "--staged"],
        cwd=repository,
        env=environment,
        check=True,
    )
    assert_sanitized(fixture)

    subprocess.run(["git", "config", "user.name", "Metadata Test"], cwd=repository, check=True)
    subprocess.run(
        ["git", "config", "user.email", "metadata@example.invalid"],
        cwd=repository,
        check=True,
    )
    subprocess.run(["git", "commit", "-q", "--no-verify", "-m", "office fixture"], cwd=repository, check=True)
    head_sha = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=repository, text=True
    ).strip()
    subprocess.run(
        [str(scripts / GIT_SANITIZER.name), "--pre-push"],
        cwd=repository,
        env=environment,
        input=f"refs/heads/main {head_sha} refs/heads/main {'0' * 40}\n",
        text=True,
        check=True,
    )


def main() -> None:
    with tempfile.TemporaryDirectory(prefix=".office-metadata-test.", dir=REPO_ROOT) as temporary:
        temporary_path = Path(temporary)
        for extension in ("docx", "pptx", "xlsx"):
            fixture = temporary_path / f"fixture.{extension}"
            create_fixture(fixture)
            raw_check = subprocess.run([str(SANITIZER), "--check", str(fixture)])
            assert raw_check.returncode != 0
            subprocess.run([str(SANITIZER), str(fixture)], check=True)
            assert_sanitized(fixture)
            subprocess.run([str(SANITIZER), "--check", str(fixture)], check=True)
        assert_git_hook_routes_office_files(temporary_path)

    print("office metadata sanitizer tests: PASS")


if __name__ == "__main__":
    main()
