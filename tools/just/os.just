set positional-arguments
set dotenv-load := true
set shell := ["bash", "-cue"]
root_dir := "../.."

# The host for which most commands work below.
default_host := env("NIXOS_HOST", "vm")

# Default command to list all commands.
list:
    just --list --unsorted -f "{{source_file()}}"

## NixOS Commands to execute ONLY on a NixOS systems ===========================
# ==============================================================================
# Prints the NixOS version (based on nixpkgs repository).
version: check-on-vm
    nixos-version --revision

# Switch the `host` (`$1`) to the latest configuration.
switch *args: check-on-vm
    just rebuild switch "${1:-}" "${@:2}"

# Switch the `host` with nix-output-monitor.
switch-visual *args: check-on-vm
    #!/usr/bin/env bash
    # We need sudo, because output-monitor will
    # not show the prompt.
    just rebuild switch "${1:-}" \
        --show-trace \
        --verbose \
        --log-format internal-json \
        "${@:2}" |& nom --json

    just diff 2

# Switch the `host` (`$1`) to the latest
# configuration but under boot entry `test`.
switch-test *args: check-on-vm
    just rebuild switch "${1:-}" -p test "${@:2}"


# Show the history of the system profile and test profiles.
history: check-on-vm
    #!/usr/bin/env bash
    set -eu
    echo "History in 'system' profile:"
    nix profile history --profile /nix/var/nix/profiles/system

    if [ -s /nix/var/nix/profiles/system-profiles/test ]; then
        echo "History in 'test' profile:"
        nix profile history --profile /nix/var/nix/profiles/system-profiles/test
    fi

# Run the trim script to reduce the amount of generations kept on the system.
trim *args: check-on-vm
    ./scripts/trim-generations.sh {{args}}

# Diff the profile `current-system` with the last system profile
# to see the differences.
diff last="1" current_profile="/run/current-system": check-on-vm
    #!/usr/bin/env bash
    set -eu

    if ! command -v nvd &>/dev/null; then
        echo "! Command 'nvd' not installed to print difference." >&2
        exit 0
    fi

    set -euo pipefail
    last="$1" # skip current system.
    current_profile="$2"

    function sort_profiles() {
        find /nix/var/nix/profiles -type l -name '*system-*' -printf '%T@ %p\0' |
        sort -zk 1nr |
        sed -z 's/^[^ ]* //' |
        tr '\0' '\n'
    }

    if [[ "$last" =~ [0-9]* ]]; then
        last_profile="$(sort_profiles | head -n "$last" | tail -n 1)"

        if [[ "$(readlink last_profile)" = "$(readlink /nix/var/nix/profiles/current-system)" ]]; then
            echo "Last profile '$last_profile' points to 'nix/var/nix/profiles/current-system' -> Skip."
            last=$(($last + 1)) # skip current system.
        fi

        last_profile="$(sort_profiles | head -n "$last" | tail -n 1)"
    else
        last_profile="$last"
    fi

    nvd diff "$last_profile" "$current_profile"

# Run Nix garbage-collection on the system-profile.
gc: check-on-vm
    echo "Remove test profile"
    sudo rm -rf /nix/var/nix/profiles/system-profile/test

    echo "Remove all generations older than 7 days"
    sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d

    echo "Garbage collect all unused nix store entries"
    sudo nix store gc --debug

# NixOS rebuild command for the `host` (defined in the flake).
[private]
rebuild how host *args: check-on-vm
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"

    host="${2:-"{{default_host}}"}"

    echo "----"
    echo nixos-rebuild {{how}} --flake ".#$host" "${@:3}"
    echo "----"

    nixos-rebuild {{how}} --flake ".#$host" "${@:3}"

[private]
check-on-vm:
    [ "${NIXOS_ON_VM:-}" = "true" ] || { \
        echo "You should only run this command inside the NixOS VM." &>2 \
    }
