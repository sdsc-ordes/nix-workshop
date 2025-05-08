set positional-arguments
set dotenv-load := true
set shell := ["bash", "-cue"]
root_dir := justfile_directory()
build_dir := root_dir / "build"
flake_dir := root_dir

# The host for which most commands work below.
default_host := env("NIXOS_HOST", "vm")

# Default command to list all commands.
list:
    just --list --unsorted

# Start a Nix dev. shell to work in this repository.
develop *args:
    just nix-develop "default" "$@"

# Start a Nix dev. shell to work on the VMs in this repository.
develop-vm *args:
    just nix-develop "default" "$@"

# Format the whole repository.
format:
    cd "{{root_dir}}" && \
      nix fmt

# Start the Nix interpreter where this flake is loaded to explore stuff.
repl:
    nix repl .

# Run `nix eval` with Nix code on stdin. Use like `echo '3' | just eval`.
eval:
    @nix eval --file -

# Run the NixOS VM image directly for `host` = (`$1` or '.env' file).
run *args:
    #!/usr/bin/env bash
    host="${1:-"{{default_host}}"}" && shift 1
    mkdir -p "{{build_dir}}"
    cd build

    nix run \
        --show-trace --verbose --log-format internal-json \
        "../#nixosConfigurations.$host.config.system.build.vmWithDisko" "$@" |& \
        nom --json

# Build the NixOS VM image for `host` = (`$1` or '.env' file). The output is in the link `build/nixos-$host`.
build *args:
    #!/usr/bin/env bash
    host="${1:-"{{default_host}}"}" && shift 1
    mkdir -p "{{build_dir}}"
    cd build

    nix build \
        --out-link "{{build_dir}}/disko-image-script" \
        --show-trace --verbose --log-format internal-json \
        "$@" \
        "..#nixosConfigurations.$host.config.system.build.diskoImagesScript" |& \
        nom --json

    sudo ./disko-image-script --build-memory 2048

## Flake Maintenance commands =================================================
# ==============================================================================
# Update the flake lock file, use `update-single` for updating a single input.
update *args:
    cd "{{root_dir}}" && nix flake update "$@"

# Update a single input in the lock file.
update-single *args:
    cd "{{root_dir}}" && nix flake lock --update-input "$@"

# Update all flakes in this repo.
[private]
update-all:
    #!/usr/bin/env bash
    readarray -t flakes < <(find . -name "flake.nix")
    for flake in "${flakes[@]}"; do
        cd "$(dirname "$flake")" && nix flake update
    done
# ==============================================================================

## Nix Misc. Commands ==========================================================
# ==============================================================================
# Diff closures from `dest_ref` to `src_ref`. This builds and computes the NixOS closure which might take some time.
diff-closure dest_ref="/" src_ref="origin/main" host="{{default_host}}":
    #!/usr/bin/env bash
    set -eu

    host="{{host}}"
    echo "Diffing closures of host '$host' from '{{src_ref}}' to '{{dest_ref}}'"

    nix store diff-closures \
        ".?ref={{src_ref}}#nixosConfigurations.$host.config.system.build.toplevel" \
        ".?ref={{dest_ref}}#nixosConfigurations.$host.config.system.build.toplevel"

# Run nix-tree to get the tree of all packages and to inspect derivations.
tree *args:
    nix-tree "$@"


# Enter the nix development shell `$1` and execute the command `${@:2}`.
[private]
nix-develop *args:
    #!/usr/bin/env bash
    set -eu
    cd "{{root_dir}}"
    shell="$1"; shift 1;
    args=("$@") && [ "${#args[@]}" != 0 ] || args="$shell"
    nix develop \
        --accept-flake-config \
        "{{flake_dir}}#$shell" \
        --command "${args[@]}"

# NixOS commands on the VM.
mod os "./tools/just/os.just"
# ==============================================================================
