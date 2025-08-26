# Step 3 - Setup a DevShell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. The function of interest is `inputs.devenv.lib.mkShell` forwards all
   arguments to `inputs.devenv.lib.mkConfig` which has the following
   **mandatory** arguments:

   ```nix
   mkConfig = {pkgs , inputs , modules}: ...
   ```

   So we need to pass `pkgs` and `inputs` and `modules`. Lets explore `modules`
   next.

2. See `flake.nix`.

3. `nix develop ".#default"` or `nix develop .` will almost work. The error you
   see

   ```shell
   error: Failed assertions:
   - devenv was not able to determine the current directory.

     See https://devenv.sh/guides/using-with-flakes/ how to use it with flakes.
   ```

   is due to the fact that evaluating a `flake.nix` does not allow to read
   environment variables (`builtins.getEnv` results in a no-op) for
   reproducibility reasons.

   So therefore you need to run it with `--no-pure-eval` to allow the evaluator
   to read env. variables such that `devenv` can determine the working
   directory.
