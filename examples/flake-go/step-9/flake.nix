{
  description = "My Nix setup for Go";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or another channel
  };

  outputs =
    inputs:
    let
      myLib = import ./nix/lib.nix;
    in
    {
      packages = myLib.forAllSystems {
        inherit (inputs) nixpkgs;
        func = import ./nix/package.nix;
      };

      devShells = myLib.forAllSystems {
        inherit (inputs) nixpkgs;

        func =
          { pkgs, ... }:
          {
            default = inputs.devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [ ./nix/go.nix ];
            };
          };
      };
    };
}
