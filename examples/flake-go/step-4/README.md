# Step 4 - Build a Nix Shell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. Lets configure the DevShell that it provides a Go toolchain. That means we
   need

   - the Go compiler
     [`pkgs.go`](https://search.nixos.org/packages?channel=unstable&show=go&query=go)

   - Also its good to provide some default packages to make the usage for other
     developers easier:

   - `coreutils`
   - `findutils`
   - `git`
   - `just`

   Add these packages to the configuration option
   [`packages`](https://devenv.sh/reference/options/#packages) in
   `nix/go.nix`.

   **Hint:** How to access `pkgs` attribute set inside `nix/go.nix` -> You
   need to make the content of `nix/go.nix` a module function.

2. Add also `nixConfig` at top-level to the `flake.nix` with a substituter from
   `devenv`:

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

   A extra substituter is another remote (or local) Nix store which Nix might
   find already built derivations and then does not need to build it on your
   machine.

3. Run the shell and try to compile & run the application in `./src`.

   **Hint:** `go run`

4. Optional, but very handy: if you configured [`direnv`] for your shell the
   file `.envrc` will let you activate the Nix shell when entering the
   directory. Initially you must run once `direnv allow`. When you made changes
   to the `flake.nix` and `Ctrl+C` in the current shell does not
   rebuild/activate the Nix shell, do `direnv reload`.
