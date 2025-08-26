# Step 2 - Setup a DevShell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. Write a function `forAllSystems` which takes 1 argument:

   - a function `func`
     ```nix
     f :: AttrSet -> AttrSet
     ```
     which takes an attribute set and returns another.

   and calls `func` for all `supportedSystems`:

   ```nix
   supportedSystems = [
     "aarch64-darwin"
     "aarch64-linux"
     "x86_64-darwin"
     "x86_64-linux"
   ];
   ```

   resulting in

   ```nix
   {
     "aarch64-linux" = f {};
     "aarch64-darwin" = f {};
     "x86_64-darwin" = f {};
     "x86_64-linux" = f {};
   }
   ```

   Hints:

   - Use `nix repl` and load the flake `:lf .`
   - Use `inputs.nixpkgs.lib` and
     [`lib.genAttrs`](https://noogle.dev/f/lib/genAttrs).
   - `let ... in` blocks.

2. Extend the function `forAllSystems` by taking an attribute set as input
   `{func, nixpkgs}` and passing the packages set `pkgs` from `nixpkgs` (for the
   system `system`) also to `func`, e.g. `func {system, pkgs}` (instead of only
   `system`):

   **Hint:** The signatures of the two functions looks like.

   ```nix
   forAllSystems :: {func, nixpkgs} -> AttrSet
   func :: {system, pkgs} -> AttrSet
   ```

3. Move that function into a file `nix/lib.nix` and import that file in the
   `flake.nix` and use it to populate the flake output
   `packages.<system>.my-fancy-app` which points to
   [`cowsay`](https://search.nixos.org/packages?channel=25.05&show=cowsay&query=cowsay)
   or another derivation of your liking.

   **Hint:** `import <path>`.

4. Run the app.

   **Hint:** Use `nix run`.
