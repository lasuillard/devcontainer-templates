#!/bin/bash
# shellcheck disable=SC2046,SC2164
cd $(dirname "$0")
# shellcheck disable=SC1091
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
# shellcheck disable=SC2002
check "greeting" [ $(cat /usr/local/etc/greeting.txt | grep hey) ]

# Report result
reportResults
