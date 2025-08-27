{
  forAllSystems =
    { func, inputs }:
    let
      supportedSystems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      # Getting the package set for a `nixpkgs` input and `system`.
      pkgsFor = nixpkgs: system: nixpkgs.legacyPackages.${system};
    in
    inputs.nixpkgs.lib.genAttrs supportedSystems (
      system:
      let
        pkgs = pkgsFor inputs.nixpkgs system;
        pkgsGo = pkgsFor inputs.nixpkgs-go system;
      in
      func {
        inherit system;

        # All unstable packages.
        inherit pkgs;

        # Partial package set for Go.
        pkgsGo = {
          # The pinned go derivation.
          go = pkgsGo.go;

          # The pinned buildGoModule support function.
          buildGoModule = pkgsGo.buildGoModule;
        };
      }
    );
}
