#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel)"
exiftool_version=13.59
exiftool_sha256=668ea3acececb7235fbd0f4900e72d5f12c9b07e5c778fd36cb1e9b5828fd65a
exiftool_url="https://sourceforge.net/projects/exiftool/files/Image-ExifTool-${exiftool_version}.tar.gz/download"
engine=""
metadata_command=()

usage() {
  printf 'Usage: %s --staged | --pre-push\n' "$(basename "$0")" >&2
}

is_supported_file() {
  local path="$1"
  local extension="${path##*.}"
  extension="${extension,,}"

  case "$extension" in
    avif|bmp|gif|heic|heif|jpeg|jpg|jxl|png|svg|svgz|tif|tiff|webp \
      |pdf|docx|pptx|xlsx|epub|odg|odp|ods|odt \
      |aac|flac|m4a|mp2|mp3|oga|ogg|opus|spx|wav \
      |avi|mkv|mov|mp4|webm|wmv)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

absolute_git_path() {
  local path
  path="$(git -C "$repo_root" rev-parse --git-path "$1")"
  if [[ "$path" == /* ]]; then
    printf '%s\n' "$path"
  else
    printf '%s/%s\n' "$repo_root" "$path"
  fi
}

verify_sha256() {
  local expected="$1"
  local file="$2"
  local actual

  if command -v sha256sum >/dev/null 2>&1; then
    actual="$(sha256sum "$file" | awk '{print $1}')"
  elif command -v shasum >/dev/null 2>&1; then
    actual="$(shasum -a 256 "$file" | awk '{print $1}')"
  else
    printf 'Metadata sanitizer requires sha256sum or shasum.\n' >&2
    return 1
  fi

  if [[ "$actual" != "$expected" ]]; then
    printf 'ExifTool checksum mismatch: expected %s, got %s\n' "$expected" "$actual" >&2
    return 1
  fi
}

bootstrap_exiftool() {
  local cache_root
  local install_dir
  local executable
  local bootstrap_dir
  local archive
  local -a tar_args=(-xzf)

  for command_name in curl perl tar; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      printf 'Metadata sanitizer requires %s when mat2 is unavailable.\n' "$command_name" >&2
      return 1
    fi
  done

  cache_root="${METADATA_SANITIZER_CACHE_DIR:-$(absolute_git_path metadata-tools)}"
  install_dir="$cache_root/Image-ExifTool-${exiftool_version}"
  executable="$install_dir/exiftool"

  if [[ ! -f "$executable" ]]; then
    mkdir -p "$cache_root"
    bootstrap_dir="$(mktemp -d "$cache_root/bootstrap.XXXXXX")"
    archive="$bootstrap_dir/Image-ExifTool-${exiftool_version}.tar.gz"

    printf 'Downloading pinned ExifTool %s...\n' "$exiftool_version" >&2
    if ! curl -fL --connect-timeout 15 --max-time 120 -sS "$exiftool_url" -o "$archive"; then
      rm -rf -- "$bootstrap_dir"
      printf 'Failed to download ExifTool. Install mat2 or retry with network access.\n' >&2
      return 1
    fi
    if ! verify_sha256 "$exiftool_sha256" "$archive"; then
      rm -rf -- "$bootstrap_dir"
      return 1
    fi

    if tar --help 2>/dev/null | grep -q -- '--no-same-owner'; then
      tar_args=(--no-same-owner -xzf)
    fi
    if ! tar "${tar_args[@]}" "$archive" -C "$bootstrap_dir"; then
      rm -rf -- "$bootstrap_dir"
      printf 'Failed to extract ExifTool.\n' >&2
      return 1
    fi
    rm -rf -- "$install_dir"
    mv -- "$bootstrap_dir/Image-ExifTool-${exiftool_version}" "$install_dir"
    rm -rf -- "$bootstrap_dir"
  fi

  metadata_command=(perl "$executable")
}

configure_engine() {
  local requested_engine="${METADATA_SANITIZER_ENGINE:-}"

  if [[ -n "$engine" ]]; then
    return 0
  fi

  if [[ -n "$requested_engine" && "$requested_engine" != mat2 && "$requested_engine" != exiftool ]]; then
    printf 'Unknown METADATA_SANITIZER_ENGINE: %s\n' "$requested_engine" >&2
    return 1
  fi

  if [[ "$requested_engine" == mat2 || ( -z "$requested_engine" && -x "$(command -v mat2 2>/dev/null || true)" ) ]]; then
    if ! command -v mat2 >/dev/null 2>&1; then
      printf 'METADATA_SANITIZER_ENGINE=mat2, but mat2 is unavailable.\n' >&2
      return 1
    fi
    engine=mat2
    metadata_command=(mat2)
  else
    engine=exiftool
    bootstrap_exiftool
  fi
}

require_pdf_rewriter() {
  local path

  [[ "$engine" == exiftool ]] || return 0
  for path in "$@"; do
    if [[ "${path##*.}" =~ ^[Pp][Dd][Ff]$ ]]; then
      if ! command -v qpdf >/dev/null 2>&1; then
        printf 'qpdf is required to permanently remove old PDF metadata.\n' >&2
        return 1
      fi
      return 0
    fi
  done
}

sanitize_file() {
  local path="$1"
  local extension="${path##*.}"
  local temporary_pdf

  extension="${extension,,}"

  if [[ "$engine" == mat2 ]]; then
    "${metadata_command[@]}" --inplace "$path"
  elif [[ "$extension" =~ ^(docx|pptx|xlsx)$ ]]; then
    if ! command -v python3 >/dev/null 2>&1; then
      printf 'python3 is required to sanitize Office files.\n' >&2
      return 1
    fi
    "$script_dir/sanitize-office-metadata.py" "$path"
  else
    "${metadata_command[@]}" -all= -overwrite_original "$path" >/dev/null
    if [[ "$extension" == pdf ]]; then
      temporary_pdf="$(mktemp "${path}.metadata-sanitize.XXXXXX.pdf")"
      if ! qpdf --warning-exit-0 --linearize "$path" "$temporary_pdf"; then
        rm -f -- "$temporary_pdf"
        return 1
      fi
      chmod --reference="$path" "$temporary_pdf" 2>/dev/null || true
      mv -f -- "$temporary_pdf" "$path"
    fi
  fi

  if [[ ! -s "$path" ]]; then
    printf 'Sanitizer produced an empty file: %s\n' "$path" >&2
    return 1
  fi
}

sanitize_staged() {
  local path
  local absolute_path
  local -a staged_paths=()
  local -a supported_paths=()

  mapfile -d '' -t staged_paths < <(
    git -C "$repo_root" diff --cached --name-only -z --diff-filter=ACMR
  )

  for path in "${staged_paths[@]}"; do
    if is_supported_file "$path"; then
      supported_paths+=("$path")
    fi
  done

  (( ${#supported_paths[@]} > 0 )) || return 0

  for path in "${supported_paths[@]}"; do
    absolute_path="$repo_root/$path"
    if [[ -L "$absolute_path" ]]; then
      printf 'Refusing to sanitize symlink: %s\n' "$path" >&2
      return 1
    fi
    if [[ ! -f "$absolute_path" ]]; then
      printf 'Missing staged file: %s\n' "$path" >&2
      return 1
    fi
    if ! git -C "$repo_root" diff --quiet -- "$path"; then
      printf 'Refusing to re-stage partially staged file: %s\n' "$path" >&2
      return 1
    fi
  done

  configure_engine
  require_pdf_rewriter "${supported_paths[@]}"

  for path in "${supported_paths[@]}"; do
    absolute_path="$repo_root/$path"
    sanitize_file "$absolute_path"
    git -C "$repo_root" add -- "$path"
    printf 'Sanitized metadata: %s\n' "$path"
  done
}

check_file() {
  local path="$1"
  local extension="${path##*.}"
  local metadata_output
  local -a privacy_tags=(
    -EXIF:all -XMP:all -IPTC:all -MakerNotes:all -Photoshop:all
    -PDF:Author -PDF:Creator -PDF:Producer -PDF:Title -PDF:Subject
    -PDF:Keywords -PDF:CreateDate -PDF:ModifyDate
    -Microsoft:all -PNG:TextualData -ID3:all
    -QuickTime:Author -QuickTime:Comment -QuickTime:CreateDate
    -QuickTime:ModifyDate -QuickTime:GPSCoordinates
  )

  extension="${extension,,}"

  if [[ "$engine" == mat2 ]]; then
    metadata_output="$("${metadata_command[@]}" --show "$path" 2>&1)"
  elif [[ "$extension" =~ ^(docx|pptx|xlsx)$ ]]; then
    "$script_dir/sanitize-office-metadata.py" --check "$path" >/dev/null 2>&1
    return
  else
    metadata_output="$("${metadata_command[@]}" -s3 "${privacy_tags[@]}" "$path" 2>&1)"
  fi

  [[ -z "${metadata_output//[[:space:]]/}" ]]
}

check_pre_push() {
  local local_ref local_sha remote_ref remote_sha
  local revision_range
  local commit_sha
  local path
  local blob_path
  local extension
  local failed=false
  local -A files_to_check=()
  local -a outgoing_commits=()
  local -a changed_paths=()

  while read -r local_ref local_sha remote_ref remote_sha; do
    [[ -n "${local_sha:-}" ]] || continue
    [[ "$local_sha" != 0000000000000000000000000000000000000000 ]] || continue
    if [[ "$remote_sha" == 0000000000000000000000000000000000000000 ]]; then
      revision_range="$local_sha"
    else
      revision_range="$remote_sha..$local_sha"
    fi

    mapfile -t outgoing_commits < <(
      git -C "$repo_root" rev-list "$revision_range"
    )
    for commit_sha in "${outgoing_commits[@]}"; do
      mapfile -d '' -t changed_paths < <(
        git -C "$repo_root" diff-tree --root --no-commit-id --name-only -r -z \
          --diff-filter=ACMR "$commit_sha"
      )
      for path in "${changed_paths[@]}"; do
        if is_supported_file "$path"; then
          files_to_check["$commit_sha:$path"]=1
        fi
      done
    done
  done

  (( ${#files_to_check[@]} > 0 )) || return 0
  configure_engine

  for blob_spec in "${!files_to_check[@]}"; do
    commit_sha="${blob_spec%%:*}"
    path="${blob_spec#*:}"
    extension="${path##*.}"
    blob_path="$(mktemp "$repo_root/.metadata-check.XXXXXX.${extension}")"
    if ! git -C "$repo_root" show "$commit_sha:$path" >"$blob_path"; then
      rm -f -- "$blob_path"
      return 1
    fi
    if ! check_file "$blob_path"; then
      printf 'Metadata detected in outgoing file: %s\n' "$path" >&2
      failed=true
    fi
    rm -f -- "$blob_path"
  done

  if [[ "$failed" == true ]]; then
    printf 'Amend the affected commit after sanitizing the file. Push blocked.\n' >&2
    return 1
  fi
}

case "${1:-}" in
  --staged)
    [[ $# -eq 1 ]] || { usage; exit 2; }
    sanitize_staged
    ;;
  --pre-push)
    [[ $# -eq 1 ]] || { usage; exit 2; }
    check_pre_push
    ;;
  *)
    usage
    exit 2
    ;;
esac
