# Step 4 - Build a DevShell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. See `flake.nix`.

2. `nix run --no-pure-eval .#default` or by running directly your favorite
   shell: `nix run --no-pure-eval .#default -- zsh`.

   Then do

   ```bash
   cd src
   go run main.go
   ```
