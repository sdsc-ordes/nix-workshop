# Step 2 - Write a Function `forAllSystems`

## Exercises

### 1. **Write a `forAllSystems` function which:**

  - takes one argument `func`
  - calls `func` for all `supportedSystems`
  - returns the result

   **Remember the nix function syntax:**
   ```nix
   myFunction = argument: 
     let
       # variables here
     in
       # result here
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
   
   - Use `inputs.nixpkgs.lib` and
     [`lib.genAttrs`](https://noogle.dev/f/lib/genAttrs).

### 2. **Enhance the function to provide access to packages which:**

   - takes an attribute set `{func, nixpkgs}` as input
   - passes `{system, pkgs}` to `func` instead of just `system`
   - returns the same structure as before

   **Function signatures:**
   ```nix
   forAllSystems :: {func, nixpkgs} -> AttrSet
   func :: {system, pkgs} -> AttrSet
   ```

### 3. **Move function to `nix/lib.nix` to:**

   - create a separate file for the function
   - import and use it in `flake.nix` 
   - create a `packages` output with [`cowsay`](https://search.nixos.org/packages?channel=25.05&show=cowsay&query=cowsay) or another derivation of your liking.

   **Hint:** `import <path>`

### 4. **Test the package which:**

   - runs the created package
   - verifies everything works

   **Hint:** Use `nix run`
