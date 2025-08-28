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

        func =
          { pkgs, ... }:
          {
            # Exercise 2.
            default = pkgs.buildGoModule {
              name = "demo";
              version = "0.1.0";
              src = ./src;
              modRoot = ".";
              vendorHash = "sha256-Nm5G4bEFwgA2+5Octhn2s6vquNtwQ82Z4bevZ5R20vU=";
            };

            # Exercise 3.
            default-other = import ./nix/package.nix {
              inherit pkgs;
              rootDir = ./.; # This is a type `path`.
            };
          };
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
