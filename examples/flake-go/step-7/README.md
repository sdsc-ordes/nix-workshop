# Step 7 - Package the Go Executable

This exercise lets you build the Go executable in [`./src`](./src) into a Nix
derivation (package) which you will expose as a package output (with name
`default`) in the [`./flake.nix`](./flake.nix).

## Exercises

1. **Build the Go executable.** To build a Nix derivation we need a build
   support function which orchestrates `go build` and other steps.

   Basically a wrapper around the more low-level `lib.stdenv.mkDerivation`, but
   not needed at this point.

   In [`nixpkgs`](https://noogle.dev/) there are several
   [Go build support function](https://noogle.dev/q?term=buildGo) of which we
   will use
   [`pkgs.buildGoModule`](https://github.com/NixOS/nixpkgs/tree/master/pkgs/build-support/go/module.nix)
   which is a function with
   [the following arguments](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix#L19).

   To not go into the nitty-gritty details about all the different methods to
   build a Go package, here is the function which does what we want:

   ```nix
   pkgs.buildGoModule {
      name = "demo";
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
     > This hash is needed for fixed-output derivations (FOD). A fixed output
     > derivation - in this case a `/nix/store` path with all downloaded Go
     > dependencies - is needed as **input** to the _final derivation_ which
     > builds our Go executable.
     >
     > Building a FOD has **internet access** (in contrary to normal derivations
     > which are sandboxed more stringent) but you must specify a **hard-coded**
     > hash to make Nix validate the fetched content, e.g. `vendorHash`.

     > [!CAUTION]
     >
     > In our case, if Nix finds the FOD for this `vendorHash` in the Nix store
     > already, it will not build the FOD again (downloading all Go
     > dependencies). That means if you do not adjust this hash when you change
     > some dependencies in `go.mod` it might use the old dependency set.

2. **Copy that `buildGoModule` snippet from above to the
   `outputs.packages.<system>.default`** and let it build. What do you
   experience?

   Inspect and run the built derivation.

   **Hint:**

   - `nix build` with `-L` and `--out-link ...` flag.

3. **Refactor with the following steps:**

   - Move the `pkgs.buildGoModule` code from the [`flake.nix`](./flake.nix) into
     a separate file `nix/package.nix` and import it at the caller site.
   - Also pass the root directory path `rootDir = ./.;` to `nix/package.nix` to
     make the `src = ...` variable depend on it.

   When `pkgs.buildGoModule` uses the value of `src`, what path does it get
   (where is this directory)?
