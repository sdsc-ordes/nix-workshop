# Step 8 - Version Pin The Go Compiler

This step is optional and only for the curious. We want to pin the Go compiler
to an exact version.

## Exercises

1. **Add a new `nixpkgs` input:** We have locked the `inputs.nixpkgs` to
   `github:NixOS/nixpkgs/nixos-unstable` together with the
   [`flake.lock`](flake.lock) file on a **certain commit** on branch
   `nixos-unstable` This `nixpkgs` version comes with a certain version of the
   Go compiler.

   On [nixhub](https://www.nixhub.io/packages/go) we can find the exact commit
   on `nixpkgs` where we want the `1.24.4` compiler.

   Add an input `inputs.nixpkgs-go` in [`flake.nix`](./flake.nix) on that
   version with URL
   `github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359` to make use
   of that compiler in the next step.

2. **Import the package set of the new input**
   `pkgsGo = import inputs.nixpkgs-go {}` and replace the `go` compiler with
   `pkgsGo.go` inside [`nix/go.nix`](nix/go.nix).

   > [!CAUTIION]
   >
   > The `pkgs` in [`nix/go.nix`](nix/go.nix) is coming from
   > `mkShell { inherit pkgs; }` which is coming from `forAllSystems`.

   Check the version of the `go` compiler inside the shell that its `1.24.4`.

   Hint: `direnv reload` if using `direnv`

3. **Make the [`nix/package.nix`](nix/package.nix) use `pkgsGo.buildModule`.**
