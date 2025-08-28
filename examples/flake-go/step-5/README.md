# Step 6 - Add Capabilities to the Nix Shell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. Add an environment variable `EXAMPLE_ENV_VAR` to `nix/go.nix`.

   **Hint:** [`env`](https://devenv.sh/reference/options/#env).

2. Add a some bash

   ```bash
   echo "🐹 Running: $(<go-executable> version) 🐹"
   ```

   script to `nix/go.nix` which is always executed when entering the Nix shell.
   Replace the `<go-executable>` with the Go executable path from the `pkgs.go`
   derivation.

   **Hint:**

   - [`enterShell`](https://devenv.sh/reference/options/#entershell).
   - [`lib.getExe`](https://noogle.dev/f/lib/getExe)

3. Optional: Add output on `enterShell` which depending on
   `config.dotenv.enable` prints path of the file which was loaded
   (`config.dotenv.filename`).
