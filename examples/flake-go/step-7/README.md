# Step 7 - Package the Go Executable

This exercise lets you build the Go executable in [`./src`](./src) into a Nix
derivation which you will expose as package on the [`./flake.nix`](./flake.nix).

## Exercises

1. To build a derivation we need a build support function which orchestrates
   `go build` and other steps. Basically a wrapper around
   `lib.stdenv.mkDerivation`. In [`nixpkgs`](https://noogle.dev/) there are
   several [Go build support function](https://noogle.dev/q?term=buildGo) of
   which we will use
   [`pkgs.buildGoModule`](https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support/go/module.nix)
   which will have the
   [function following arguments](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix#L19).

   To not go into the nitty-gritty details about all the different methods to
   build a Go package, here is the function which does that:

   ```nix
   pkgs.buildGoModule {
      name = "go-demo";
      version = "0.1.0";
      src = ./src;

      modRoot = ".";
      vendorHash = "sha256-Nm5G4bEFwgA2+5Octhn2s6vquNtwQ82Z4bevZ5R20v4=";
   }
   ```

   - `name` is the derivation name - a std.
     [derivation argument](https://nixos.org/manual/nixpkgs/stable/#sec-using-stdenv).

   - `version` is a (semantic) version string.

   - `modRoot` is where the [`go.mod`](./src/go.mod) file is located relative to
     the path `src = ./src`.

   - `vendorHash` is a SHA256 hash of all dependencies in
     [`go.mod`](./src/go.mod).

     > [!NOTE]
     >
     > This is needed for fixed-output derivations (FOD). A fixed output
     > derivation (in this case a `/nix/store` path with all downloaded Go
     > dependencies) is needed as **input** to the _final derivation_ which does
     > the Go build. A FOD has **access to the internet** (in contrary to normal
     > derivations) but a **hard-coded** hash has to be given explicitly, e.g.
     > `vendorHash`.

2. Copy that `buildGoModule` snippet from above to the
   `outputs.packages.<system>.default` and let it build. What do you experience?

   **Hint:**

   - `nix build` with `-L` and `--out-link ...` flag.

   Inspect and run the built derivation.
