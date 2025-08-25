{
  description = "Go project with a development and package derivation";
  nixConfig = {
    extra-trusted-substituters = [
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };
  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05"; # or another channel
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      devenv,
    }:
    let
      forAllSystems = import ./nix/systems.nix;
    in
    {
      packages = forAllSystems {
        pkgs = nixpkgs;
        func = import ./nix/package.nix;
      };

      devShells = forAllSystems {
        pkgs = nixpkgs;
        func =
          { pkgs, ... }:
          {
            default = devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                ./nix/go.nix
              ];
            };
          };
      };
    };
}
