#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
test_root="$(mktemp -d "$repo_root/.metadata-test.XXXXXX")"
trap 'rm -rf -- "$test_root"' EXIT

sanitizer="$repo_root/scripts/sanitize-metadata.sh"
pre_commit_hook="$repo_root/.githooks/pre-commit"
pre_push_hook="$repo_root/.githooks/pre-push"
installer="$repo_root/scripts/install-git-hooks.sh"

for executable in "$sanitizer" "$pre_commit_hook" "$pre_push_hook" "$installer"; do
  if [[ ! -x "$executable" ]]; then
    printf 'Missing executable: %s\n' "$executable" >&2
    exit 1
  fi
done

fake_bin="$test_root/bin"
mkdir -p "$fake_bin"

cat >"$fake_bin/mat2" <<'FAKE_MAT2'
#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
  --inplace)
    shift
    for file in "$@"; do
      sed -i 's/PRIVATE_META/CLEAN/g' "$file"
    done
    ;;
  --show|-s)
    shift
    for file in "$@"; do
      if grep -q 'PRIVATE_META' "$file"; then
        printf '[+] Metadata for %s:\n  Author: Test Author\n' "$file"
      fi
    done
    ;;
  --version|-v)
    printf '0.test\n'
    ;;
  *)
    printf 'Unexpected fake mat2 arguments: %s\n' "$*" >&2
    exit 2
    ;;
esac
FAKE_MAT2
chmod +x "$fake_bin/mat2"

fixture_repo="$test_root/repo"
mkdir -p "$fixture_repo/scripts" "$fixture_repo/.githooks"
cp "$sanitizer" "$installer" "$fixture_repo/scripts/"
cp "$pre_commit_hook" "$pre_push_hook" "$fixture_repo/.githooks/"

git -C "$fixture_repo" init -q
git -C "$fixture_repo" config user.name 'Metadata Test'
git -C "$fixture_repo" config user.email 'metadata@example.invalid'

PATH="$fake_bin:$PATH" "$fixture_repo/scripts/install-git-hooks.sh"
[[ "$(git -C "$fixture_repo" config --get core.hooksPath)" == '.githooks' ]]

printf 'pixels PRIVATE_META\n' >"$fixture_repo/photo.jpg"
printf 'PRIVATE_META must remain in text\n' >"$fixture_repo/notes.txt"
git -C "$fixture_repo" add photo.jpg notes.txt
PATH="$fake_bin:$PATH" METADATA_SANITIZER_ENGINE=mat2 \
  git -C "$fixture_repo" commit -q -m 'add files'

git -C "$fixture_repo" show HEAD:photo.jpg | grep -q 'pixels CLEAN'
git -C "$fixture_repo" show HEAD:notes.txt | grep -q 'PRIVATE_META must remain in text'

printf 'pixels PRIVATE_META\n' >"$fixture_repo/partial.jpg"
git -C "$fixture_repo" add partial.jpg
printf 'unstaged edit\n' >>"$fixture_repo/partial.jpg"
if PATH="$fake_bin:$PATH" METADATA_SANITIZER_ENGINE=mat2 \
  "$fixture_repo/scripts/sanitize-metadata.sh" --staged >/dev/null 2>&1; then
  printf 'Expected partial-stage sanitization to fail\n' >&2
  exit 1
fi
git -C "$fixture_repo" show :partial.jpg | grep -q 'PRIVATE_META'
grep -q 'unstaged edit' "$fixture_repo/partial.jpg"

git -C "$fixture_repo" reset -q HEAD partial.jpg
rm "$fixture_repo/partial.jpg"
base_sha="$(git -C "$fixture_repo" rev-parse HEAD)"
printf 'document PRIVATE_META\n' >"$fixture_repo/dirty.pdf"
git -C "$fixture_repo" add dirty.pdf
git -C "$fixture_repo" commit -q --no-verify -m 'add dirty pdf'

printf 'document CLEAN\n' >"$fixture_repo/dirty.pdf"
git -C "$fixture_repo" add dirty.pdf
git -C "$fixture_repo" commit -q --no-verify -m 'clean dirty pdf later'
clean_sha="$(git -C "$fixture_repo" rev-parse HEAD)"

if printf 'refs/heads/main %s refs/heads/main %s\n' "$clean_sha" "$base_sha" \
  | (cd "$fixture_repo" && PATH="$fake_bin:$PATH" METADATA_SANITIZER_ENGINE=mat2 \
    .githooks/pre-push origin example.invalid) >/dev/null 2>&1; then
  printf 'Expected pre-push metadata check to fail\n' >&2
  exit 1
fi

exiftool_cache="$test_root/exiftool-cache"
mkdir -p "$exiftool_cache/Image-ExifTool-13.59"
cat >"$exiftool_cache/Image-ExifTool-13.59/exiftool" <<'FAKE_EXIFTOOL'
#!/usr/bin/env perl
exit 0;
FAKE_EXIFTOOL

cat >"$fake_bin/qpdf" <<'FAKE_QPDF'
#!/usr/bin/env bash
set -euo pipefail

warning_exit_zero=false
if [[ "${1:-}" == '--warning-exit-0' ]]; then
  warning_exit_zero=true
  shift
fi
[[ "${1:-}" == '--linearize' ]]
cp -- "$2" "$3"
[[ "$warning_exit_zero" == true ]] || exit 3
FAKE_QPDF
chmod +x "$fake_bin/qpdf"

printf 'warning-only PDF rewrite\n' >"$fixture_repo/warning.pdf"
git -C "$fixture_repo" add warning.pdf
if ! PATH="$fake_bin:$PATH" \
  METADATA_SANITIZER_ENGINE=exiftool \
  METADATA_SANITIZER_CACHE_DIR="$exiftool_cache" \
  "$fixture_repo/scripts/sanitize-metadata.sh" --staged >/dev/null 2>&1; then
  printf 'Expected qpdf warning-only exit to be accepted\n' >&2
  exit 1
fi

printf 'metadata sanitizer tests: PASS\n'
