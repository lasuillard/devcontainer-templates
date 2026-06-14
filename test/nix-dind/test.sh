#!/usr/bin/env bash

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
source test-utils.sh

check "distro" lsb_release --codename
check "current user" whoami

# NOTE: This check makes use of `nix` available for later checks,
#       otherwise checks will fail with `nix` not found
check "nix available" /nix/var/nix/profiles/default/bin/nix --version

check "experimental flakes enabled" sh -c 'nix config show experimental-features | grep --quiet flakes'
check "experimental nix-command enabled" sh -c 'nix config show experimental-features | grep --quiet nix-command'

check "docker available" docker --version

report_results
