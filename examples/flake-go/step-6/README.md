# Step 6 - Add Custom Options to a DevShell With [`devenv.sh`](https://devenv.sh)

This step is optional and only for the curious.

## Exercises

1. `devenv`'s module system (the same as NixOS module system) lets you easily
   extend it. Lets say we want a custom option to be available like so

   ```nix
     nix-workshop.run-script  = {
       enable = true;
       path = "src/mycode.go";
     }
   ```

   which will make an executable `run-it` (shell script) available in the shell.
   It will do a simple `go run src/mycode.go` basically.

   For that write a `devenv` module `nix/module-run-script.nix` which will
   implement `config.script.run-it` based on the configured
   `options.nix-workshop.run-script`.

   **Hint:**:

   - To make an option [`lib.mkOption`](https://noogle.dev/f/lib/mkOption).
   - To make things conditional
     [`lib.mkIf`](https://noogle.dev/f/lib/modules/mkIf).

2. Import the new module in [`nix/go.nix`](nix/go.nix) with the new
   top-level option `imports` (lets you import other `devenv` modules):

   ```nix
   imports = [
     ./module-run-script.nix
   ];
   ```

   Finally use the option in `nix/go.nix`.

3. Enter the shell and run the executable `run-it`.
