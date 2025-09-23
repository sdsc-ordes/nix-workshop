{
  # Calls `func` with `{ system = ...; pkgs = ... }` and returns
  # {
  #   aarch64-linux = func { system = ...; pkgs = ...};
  #   x86_64-linux= func { system = ...; pkgs = ...};
  #   ...
  # }
  forAllSystems =
    { func, nixpkgs }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    nixpkgs.lib.genAttrs supportedSystems (
      system:
      func {
        inherit system;
        pkgs = pkgsFor system;
      }
    );
}
