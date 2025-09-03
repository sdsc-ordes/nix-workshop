# Example Flake for Go

## Development Shell

This example Go module comes with a Nix flake that provides a go development
shell. This ensures all developers work with the same toolchain and tooling
versions (language server, linter, ...).

Enter the Nix development shell with `nix develop --no-pure-eval .` and then
build the go package with `go build main.go`.

Inspect the shell setup by looking at [`flake.nix`](./flake.nix).

## Nix Builds

### Executable Package

In addition, the flake declares a package in its output (attribute
`outputs.packages.${system}.default)`. To directly build the Go executable with
Nix use `nix build ".#default"` or just `nix build .`

### Container Image

Also it contains a container image as a flake output, e.g. attribute
`outputs.packages.${system}.image`, which runs the executable from
`outputs.packages.${system}.default`.

You can build and run the image with:

```shell
nix build ".#image"

podman load < result
podman run -it demo:latest

# Use `docker` instead of podman.
```
