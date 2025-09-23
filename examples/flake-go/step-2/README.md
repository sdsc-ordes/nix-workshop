# Step 2 - Write a Function `forAllSystems`

## Exercises

1. **Write a `forAllSystems` function with the following properties**:

- Takes one argument `func` which is a function

  **Remember the `nix` function syntax:**

  ```nix
  myFunction = argument:
    let
      # variables here
    in
      # result here (don't forget the ';' at the end)
  ```

- Calls function `func` for all `supportedSystems`:

  ```nix
  supportedSystems = [
    "aarch64-darwin"  # Apple Silicon Macs
    "aarch64-linux"   # ARM Linux
    "x86_64-darwin"   # Intel Macs
    "x86_64-linux"    # Intel/AMD Linux
  ];
  ```

- Returns the result of the call which should produce the following attribute
  set:

  ```nix
  {
    "aarch64-darwin" = func "aarch64-darwin" ;
    "aarch64-linux"  = func "aarch64-linux" ;
    "x86_64-darwin"  = func "x86_64-darwin" ;
    "x86_64-linux"  = func "x86_64-linux" ;
  }
  ```

**Hints:**

- Read the documentation online
  [`lib.genAttrs`](https://noogle.dev/f/lib/genAttrs) and try it in
  `nix repl -f <nixpkgs>`.

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
