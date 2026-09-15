#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(git -C "$script_dir" rev-parse --show-toplevel)"
current_hooks_path="$(git -C "$repo_root" config --get core.hooksPath || true)"

if [[ -n "$current_hooks_path" && "$current_hooks_path" != .githooks ]]; then
  printf 'Refusing to replace existing core.hooksPath: %s\n' "$current_hooks_path" >&2
  exit 1
fi

git -C "$repo_root" config core.hooksPath .githooks
printf 'Git hooks enabled from .githooks\n'
