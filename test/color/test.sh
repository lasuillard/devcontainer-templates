#!/bin/bash
# shellcheck disable=SC2164,SC2046
cd $(dirname "$0")
# shellcheck disable=SC1091
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
# shellcheck disable=SC2002
check "color" [ $(cat /tmp/color.txt | grep red) ]

# Report result
reportResults
