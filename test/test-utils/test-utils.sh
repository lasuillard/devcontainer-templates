#!/bin/bash

failed=()

echo_stderr() {
  echo "$@" 1>&2
}

check() {
  label=$1
  shift
  echo -e "\n🧪 Testing '${label}'"
  if "$@"; then
    echo "✅ Passed!"
    return 0
  else
    echo_stderr "❌ Check '${label}' failed."
    failed+=("$label")
    return 1
  fi
}

report_results() {
  if [ ${#failed[@]} -ne 0 ]; then
    # shellcheck disable=SC2145
    echo_stderr -e "\n💥 Failed tests:"
    for label in "${failed[@]}"; do
      echo_stderr "  ${label}"
    done
    echo_stderr
    exit 1
  else
    echo -e "\n💯 All passed!\n"
    exit 0
  fi
}
