# Step 8 - Use `override` to Exchange The go Compiler

This step is optional and only for the curious.

## Exercises

1. See [`flake.nix`](.flake.nix).

2. See [`flake.nix`](.flake.nix) & [`nix/go.nix`](nix/go.nix) &
   [`nix/lib.nix`](nix/lib.nix).

3. See [`nix/package.nix`](nix/package.nix).

   > [!NOTE] See [`nix/package-overide.nix`](nix/package-overide.nix) You can
   > achieve the same by using `pkgs.buildGoModule` still from `pkgs` of the
   > unstable `inputs.nixpkgs` but with older compiler:
   >
   > ```nix
   > pkgs.buildGoModule.override { go = pkgsGo.go; };
   > ```
   >
   > The difference is that we now just use the `buildGoModule` function
   > (defining how the package is built) from `inputs.nixpkgs` (unstable). This
   > solution is preferred.
   >
   > `override` is a function on `buildGoModule` (and also exists on derivation
   > like `pkgs.go.override`) which lets you override the inputs of
   > `buildGoModule`. The function `buildGoModule` has inputs which can be seen
   > [here](https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/go/module.nix#L1):
   >
   > ```nix
   > {
   >   go,
   >   cacert,
   >   gitMinimal,
   >   lib,
   >   stdenv,
   > }: ...
   > ```
