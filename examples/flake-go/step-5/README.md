# Step 6 - Add Capabilities to the Nix Shell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. **Add an environment variable `EXAMPLE_ENV_VAR` to the Nix Shell** in
   `nix/go.nix`. such that it is available when entering it.

   **Hint:** [`env`](https://devenv.sh/reference/options/#env).

2. **Add a bash script**

   ```bash
   echo "🐹 Running: $(<go-executable> version) 🐹"
   ```

   to `nix/go.nix` which is always executed when entering the Nix shell. Replace
   the `<go-executable>` with the Go executable path from the `pkgs.go`
   derivation.

   **Hint:**

   - [`enterShell`](https://devenv.sh/reference/options/#entershell).
   - [`lib.getExe`](https://noogle.dev/f/lib/getExe)

3. Optional: Add an output in `enterShell` which depending on
   `config.dotenv.enable` prints the path of the environment file which was
   loaded (`config.dotenv.filename`).

   **Hint:**

   - [`dotenv.enable`](https://devenv.sh/reference/options/#dotenvenable).
