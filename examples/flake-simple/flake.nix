{
  description = "Simple Flake";

  nixConfig = {
    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs (unstable stuff for certain packages.)
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      nixpkgs,
      ...
    }@inputs:
    let
      # Supported systems for your flake packages, shell, etc.
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;

      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              pkgs.skopeo
              pkgs.cowsay
            ];

            shellHook = ''
              ${pkgs.cowsay}/bin/cowsay  "Hello from Shell"
            '';
          };
        }
      );

      packages = forAllSystems (
        system:
        let
          # That import is the same as the above.
          pkgs = (import inputs.nixpkgs-unstable) {
            inherit system;
          };

          # Load some packages.
          mypkgs = (import ./pkgs) pkgs;
        in
        {
          inherit (mypkgs) mytool banana-icecream;
        }
      );

    in
    {
      inherit packages devShells;
    };
}
