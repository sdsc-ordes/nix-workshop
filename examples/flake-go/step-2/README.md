# Step 2 - Write a Function `forAllSystems`

## Exercises

1. **Write a `forAllSystems` function which:**

- takes one argument `func`
- calls `func` for all `supportedSystems`
- returns the result

  **Remember the `nix` function syntax:**

  ```nix
  myFunction = argument:
    let
      # variables here
    in
      # result here (don't forget the ';' at the end)
  ```

**Define supported systems:**

```nix
supportedSystems = [
  "aarch64-darwin"  # Apple Silicon Macs
  "aarch64-linux"   # ARM Linux
  "x86_64-darwin"   # Intel Macs
  "x86_64-linux"    # Intel/AMD Linux
];
```

**Hints:**

- Read the documentation online
  [`lib.genAttrs`](https://noogle.dev/f/lib/genAttrs).
- Use `nix repl` and load the flake `:lf .` and read the documentation with with
  `:e inputs.nixpkgs.lib`.

2. **Enhance the function to provide access to packages which:**

- Takes an attribute set `{func, nixpkgs}` as input.
- Imports the package attribute set from `nixpkgs` into variable `pkgs`.
- Passes `{system, pkgs}` to `func` instead of just `system`.
- Returns the same structure as before.

**Function signatures:**

```nix
forAllSystems :: {func, nixpkgs} -> AttrSet
func :: {system, pkgs} -> AttrSet
```

3. **Move the function to `nix/lib.nix`:**

- Create a separate file for the function.
- Import and use it in `flake.nix`.
- Create a `packages` output with
  [`cowsay`](https://search.nixos.org/packages?channel=25.05&show=cowsay&query=cowsay)
  or another derivation of your liking.

**Hint:** `import <path>`

### 4. **Test the package which:**

- Runs the created package.
- Verifies everything works.

**Hint:** Use `nix run`
