# Step 1 - Setup a Flake

## Exercises

1. **Create a branch on the repository, e.g. `feat/solution-gabriel-nuetzi`.**

2. Extend the `flake.nix` file by

- Adding a proper description.

- Populating it with the `inputs`:

  ```nix
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or another channel
  };
  ```

> [!NOTE]
>
> You need to always **add all files** to Git with `git add .` otherwise and
> `nix` invocation will not **see** these file!

3. Create the lock file `flake.lock`. Hints: `nix flake --help`.

4. Run `nix flake show` and inspect the output. Why is it empty?
