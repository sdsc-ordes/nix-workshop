#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091,SC2015
set -u
set -e
set -o pipefail

. "$CONTAINER_SETUP_DIR/common/log.sh"

print_info "Installing direnv, just ..."

nix profile add "nixpkgs#direnv" "nixpkgs#just"
