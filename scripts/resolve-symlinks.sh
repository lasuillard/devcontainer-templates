#!/usr/bin/env bash

while IFS= read -r -d '' file; do
  echo "Resolving symlink ${file} to its target..."
  cp --dereference "$file" "${file}.tmp"
  rm "$file"
  mv "${file}.tmp" "$file"
done < <(find . -type l -print0)
