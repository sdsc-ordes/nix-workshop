# Step 4 - Build a Nix Shell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. **Lets configure the Nix Shell such that it provides a Go toolchain.** That
   means we need:

   - The Go compiler
     [`pkgs.go`](https://search.nixos.org/packages?channel=unstable&show=go&query=go).

   - Also its good to provide some common tools to make the usage for other
     developers easier, namely

   - `coreutils`
   - `findutils`
   - `git`
   - `just`

   Add these packages to the configuration option
   [`packages`](https://devenv.sh/reference/options/#packages) in `nix/go.nix`.

   **Hint:** How to access `pkgs` attribute set inside `nix/go.nix` -> You need
   to make the content of `nix/go.nix` a `devenv` module function.

2. **Add also an attribute name `nixConfig` at top-level to the `flake.nix` with
   a substituter from `devenv`:**

   ```nix
   nixConfig = {
     extra-trusted-substituters = [
       "https://devenv.cachix.org"
     ];
     extra-trusted-public-keys = [
       "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
     ];
   };
   ```

   > [!TIP] An extra substituter is another remote (or local) Nix store where
   > Nix might find (substitutes) missing built derivations. Its a binary cache
   > for packages (derivations).

3. **Run the shell** and try to compile & run the application in `./src`.

   **Hint:** `go run`

4. Optional, but very handy: if you configured
   [`direnv`](https://direnv.net/docs/hook.html) for your shell the file
   `.envrc` will let you activate the Nix shell when entering **the directory**.
   Initially you must run `direnv allow` once. When you made changes to the
   `flake.nix` and a `Ctrl+C` in the current shell does not rebuild/activate the
   Nix shell, do `direnv reload`.
