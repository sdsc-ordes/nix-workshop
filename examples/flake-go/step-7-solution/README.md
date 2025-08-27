# Step 7 - Package the Go Executable

## Exercises

1. Nothing.

2. See [`flake.nix`](./flake.nix). The derivation does not build with
   `nix build -L "./#default"` because the `vendorHash` does not match. If you
   adjust for that, the derivation builds.

   Running the `./result/bin/demo` should work.

   ```bash
   ls -ald ./result
   > /nix/store/c8yfq7kwrwa2bflbn15fgafb95sv1wfl-go-demo
   ```

   > [!NOTE]
   >
   > The Nix derivation is called `go-demo` but the executable inside is named
   > `bin/demo` due to how Go builds executables and how `pkgs.buildGoModule`
   > behaves.
