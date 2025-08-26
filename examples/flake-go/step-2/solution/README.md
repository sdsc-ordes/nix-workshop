# Step 2 - Setup a DevShell with [`devenv.sh`](https://devenv.sh)

## Exercises

1. The function looks as follows:

```nix
forAllSystems = func:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    inputs.nixpkgs.lib.genAttrs supportedSystems (
      system:
      func {
        inherit system;
      }
    )
```

which you can call like

```nix
res = forAllSystems (system: {
  a = "hello"
  b = "world-from-system-${system}"
})
```

2. The function looks now as follows:

```nix
forAllSystems = {func, nixpkgs}:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    nixpkgs.lib.genAttrs supportedSystems (
      system:
      func {
        pkgs = nixpkgs.legacyPackages.${system};
      }
    )
```

3. See `flake.nix`.

4. Use

```nix
nix run ".#my-fancy-app" -- "wow, I got it working"`
```
