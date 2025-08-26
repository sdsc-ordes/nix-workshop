# Step 3 - Build a DevShell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. Optional: Explore the function `mkShell` in `inputs.devenv.lib` with
   `nix repl`. What are the arguments?

   **Hint:** `nix repl` -> `:lf .` and `:e`

2. The function `inputs.devenv.lib.mkShell` takes among `pkgs` and `inputs` the
   most important attribute name `modules`.

   ```nix
   inputs.devenv.lib.mkShell {
     pkgs = ...;
     inputs = ...;
     modules = [...]; # This defines our shell.
   }
   ```

   The `modules` is a **list** of `devenv` modules. A module can either be

   - a function `{config, pkgs, ...}: { ... }` returning an attribute set with
     configuration structured in alignment to what you devenv expects.

   - a simple attribute set with such a `devenv` configuration.

   - or a path (e.g. `./mymodule.nix`) to a file containing one of the above two
     in which case it will simply `import` it.

   What options you can configure with such a module
   [is described in the documentation](https://devenv.sh/reference/options/).

   **Now:** Generate an output `devShells.<system>.default` with `forAllSystem`
   which results to a `mkShell` call. Pass `modules` of `mkShell` a path to
   `./nix/go.nix` which contains an empty attribute set for now.

3. Test the shell by entering it.

   **Hint:** `nix develop`
