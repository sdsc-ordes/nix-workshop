# Example Flake for Go

## Development Shell

This example Go module comes with a Nix flake that provides a go development
shell. This ensures all developers work with the same toolchain and tooling
versions (language server, linter, ...).

Enter the Nix development shell with `nix develop --no-pure-eval .` and then build the go package
with `go build main.go`.

Inspect the shell setup by looking at [`flake.nix`](nix/go.nix).

## Nix Builds

In addition, the flake declares a package in its output (attribute `outputs.packages.${system}.default)`. To directly build the Go executable with Nix use `nix build ".#default"` or just `nix build .`

A further enhancement would be to add a container image as a flake output, e.g. attribute `outputs.packages.${system}.image`, and inject the executable derivation `outputs.packages.${system}.default` into it.
