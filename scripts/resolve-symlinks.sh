#!/usr/bin/env bash

: '
Resolve all symlinks to their targets for release.
'

set -o errexit
set -o nounset
set -o pipefail

while IFS= read -r -d '' file; do
  echo "Resolving symlink ${file} to its target..."
  cp --dereference "$file" "${file}.tmp"
  rm "$file"
  mv "${file}.tmp" "$file"
done < <(find . -type l -print0)
