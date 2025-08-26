# A simple library which some functions.
{
  forAllSystems =
    {
      nixpkgs,
      func,
    }:
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
        pkgs = import nixpkgs { inherit system; };
      }
    );
}
