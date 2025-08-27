{
  description = "My Nix setup for Go";

  inputs = {
    devenv.url = "github:cachix/devenv";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-go.url = "github:NixOS/nixpkgs/a421ac6595024edcfbb1ef950a3712b89161c359";
  };

  outputs =
    inputs:
    let
      myLib = import ./nix/lib.nix;
    in
    {
      packages = myLib.forAllSystems {
        inherit inputs;

        func =
          { pkgsGo, ... }:
          {
            default = import ./nix/package.nix {
              pkgs = pkgsGo; # Note here we use `pkgsGo` to build with the right version.
              rootDir = ./.;
            };
          };
      };

      devShells = myLib.forAllSystems {
        inherit inputs;

        func =
          { pkgs, pkgsGo, ... }:
          let
            # Configure the module function with `pkgsGo`.
            goModule = import ./nix/go.nix { inherit pkgsGo; };
          in
          {
            default = inputs.devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [ goModule ];
            };
          };
      };
    };
}
