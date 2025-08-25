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
      l = import ./nix/lib.nix; # Import our functions.
    in
    {
      packages = l.forAllSystems {
        inherit nixpkgs;
        func = import ./nix/package.nix;
      };

      devShells = l.forAllSystems {
        inherit nixpkgs;
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
