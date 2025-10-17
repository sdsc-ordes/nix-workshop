set positional-arguments
set dotenv-load := true
set shell := ["bash", "-cue"]
root_dir := justfile_directory()
build_dir := root_dir / "build"
flake_dir := root_dir

# The host for which most commands work below.
default_host := env("NIXOS_HOST", "vm")
# If `remote-viewer` should be used for `qemu` (SPICE).
default_qemu_remote_viewer := env("QEMU_REMOTE_VIEWER", "true")

# You can chose either "podman" or "docker"
container_mgr := env("CONTAINER_MGR", "podman")

# Default command to list all commands.
[group('general')]
list:
    just --list --unsorted

# Start a Nix dev. shell to work in this repository.
[group('general')]
develop *args:
    just nix-develop "default" "$@"

# Format the whole repository.
[group('general')]
format:
    cd "{{root_dir}}" && \
      nix fmt

# Start the Nix interpreter where this flake is loaded to explore stuff.
[group('nix')]
repl:
    nix repl .

# Run `nix eval` with Nix code on stdin. Use like `echo '3' | just eval`.
[group('nix')]
eval:
    @nix eval --file -

# Build the NixOS VM image directly for `host` ('.env' file).
[group('nixos')]
build *args:
    #!/usr/bin/env bash
    host="${1:-"{{default_host}}"}"
    out_dir="{{build_dir}}/$host"
    mkdir -p "$out_dir"
    cd "$out_dir"

    nix build \
        --out-link "vmWithDisko" \
        --show-trace --verbose --log-format internal-json \
        "{{root_dir}}#nixosConfigurations.$host.config.system.build.vmWithDisko" "$@" |& \
        nom --json


    nix build \
        --out-link "vm" \
        --show-trace --verbose --log-format internal-json \
        "{{root_dir}}#nixosConfigurations.$host.config.system.build.vm" "$@" |& \
        nom --json

    echo "Build successful: $out_dir/vmWithDisko"

# Run the NixOS VM image directly for `host` (.env' file).
[group('nixos')]
run *args:
    #!/usr/bin/env bash
    host="${1:-"{{default_host}}"}"
    out_dir="{{build_dir}}/$host"

    if [ ! -f "$out_dir/vmWithDisko/bin/disko-vm" ]; then
        echo "Host '$host' not build. Use 'just build'." >&2
        exit 1
    else
        echo "Host '$host' already build."
    fi

    qemu_args=()
    if [ "{{default_qemu_remote_viewer}}" = "true" ]; then
        qemu_args+=(
            -spice unix=on,addr=$out_dir/spice.sock,disable-ticketing=on
            -device virtio-serial-pci
            -chardev spicevmc,id=ch1,name=vdagent
            -device virtserialport,chardev=ch1,name=com.redhat.spice.0
        )

        echo "IMPORTANT: ----------------------"
        echo "IMPORTANT: Connect with 'remote-viewer spice+unix://$out_dir/spice.sock'"
        echo "IMPORTANT: ----------------------"
    else
        qemu_args+=(
            -display gtk,gl=on
        )
    fi

    if [ ! -f "$out_dir/vmWithDisko/bin/disko-vm" ]; then
        echo "Host '$host' not build. Use 'just build'."
    fi

    echo "Starting with '$out_dir/vmWithDisko/bin/disk-vm"

    # FIXME: Forward qemu opts like this: https://github.com/nix-community/disko/pull/1142
    QEMU_OPTS="${qemu_args[@]}" "$out_dir/vmWithDisko/bin/disko-vm"


# Build the NixOS VM image for `host` = ('.env' file). The output is in the link `build/nixos-$host`.
[group('nixos')]
build-image *args:
    #!/usr/bin/env bash
    host="${1:-"{{default_host}}"}"
    out_dir="{{build_dir}}/$host"
    mkdir -p "$out_dir"
    cd "$out_dir"

    nix build \
        --out-link "disko-image-script" \
        --show-trace --verbose --log-format internal-json \
        "$@" \
        "{{root_dir}}#nixosConfigurations.$host.config.system.build.diskoImagesScript" |& \
        nom --json

    sudo ./disko-image-script --build-memory 2048

## Flake Maintenance commands =================================================
# ==============================================================================
# Update the flake lock file, use `update-single` for updating a single input.
[group('flake')]
update *args:
    cd "{{root_dir}}" && nix flake update "$@"

# Update a single input in the lock file.
[group('flake')]
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

# Build the container for `.devcontainer`.
[group('aux')]
build-dev-container *args:
    cd "{{root_dir}}/tools/devcontainer" && \
      "{{container_mgr}}" build \
      --build-arg "REPOSITORY_COMMIT_SHA=$(git rev-parse --short=11 HEAD)" \
      -f Containerfile \
      -t ghcr.io/sdsc-ordes/nix-workshop:latest \
      "$@" \
      .

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
[group('aux')]
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
