# Step 1 - Setup a Flake

## Exercises

1. **Create a branch on the repository, e.g. `feat/solution-gabriel-nuetzi`.**

2. **Extend the `flake.nix` file by:**

   **a) Adding a description:**

   Add a `description` field that explains what this flake does. The description
   should be a clear, one-sentence summary.

   **b) Adding the required inputs:**

   Add an `inputs` section that tells Nix which external flakes and package
   repositories you depend on:

   ```nix
   inputs = {
     devenv.url = "github:cachix/devenv";
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or another channel
   };
   ```

   - The input `devenv` provides tools for creating development environments.
   - The input `nixpkgs` is the main Nix package repository containing thousands
     of packages.

> [!NOTE]
>
> You need to always **add all files** to Git with `git add .` otherwise `nix`
> invocation will not **see** these files!

3. **Create the lock file `flake.lock`.**

   The `flake.lock` pins the exact versions of your inputs. Run this command for
   some help.

   ```bash
   nix flake --help
   ```

4. **Run `nix flake show` and inspect the output. Why is it empty?**

   ```bash
   nix flake show
   ```
