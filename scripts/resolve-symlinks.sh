#!/usr/bin/env bash

while IFS= read -r -d '' file; do
  echo "Processing $file"
  # cp --dereference "$file" "${file}.tmp"
  # rm "$file"
  # mv "${file}.tmp" "$file"
done < <(find . -type l -print0)
