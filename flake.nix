{
  description = "NixOS Workshop";

  nixConfig = {
    substituters = [
      # Replace the official cache with a mirror located in China
      # Add here some other mirror if needed.
      "https://cache.nixos.org/"
    ];
    extra-substituters = [
      # Nix community's cache server
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    # Nixpkgs (stuff for the system.)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    # Nixpkgs (unstable stuff for certain packages.)
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Index the nix-store with `nix-locate`.
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Some Hardware Modules.
    hardware = {
      url = "github:NixOS/nixos-hardware";
    };

    # Home-Manager for NixOS.
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Format the repo with nix-treefmt.
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Declarative Disk partitioning for VMs.
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Age Encryption Tool for NixOS.
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs:
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
      forAllSystems = inputs.nixpkgs.lib.genAttrs systems;

      # Formatter for all files.
      formatter = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          treefmtEval = inputs.treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
          treefmt = treefmtEval.config.build.wrapper;
        in
        treefmt
      );

      # Your custom packages: Accessible through 'nix build', 'nix shell', etc.
      packages = forAllSystems (
        system:
        let
          myPkgs = (import ./pkgs) inputs.nixpkgs.legacyPackages.${system};
        in
        myPkgs // { treefmt = inputs.self.outputs.formatter.${system}; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };

      # Reusable nixos modules you might want to export.
      nixosModules = import ./modules/nixos;

      # NixOSk configuration entrypoint: Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations =
        let
          inherit (inputs.self) outputs;
        in
        import ./nixos { inherit inputs outputs; };

      # The deploy configuration for `deploy-rs` tool to
      # push the VM to the cloud.
      deploy = {
        nodes.workshop-cloud-vm = {
          hostname = "workshop-cloud-vm";
          fastConnection = true;
          profiles = {
            system = {
              user = "root";
              sshUser = "root";
              path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations.vm;
            };
          };
        };
      };

      # Development shell to work in this repository.
      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
          defaultPkgs = [
            pkgs.nix-output-monitor
            pkgs.just
          ];
        in
        {
          default = pkgs.mkShell {
            packages = defaultPkgs;
          };

          vm = pkgs.mkShell {
            packages = defaultPkgs ++ [
              pkgs.virt-manager
              pkgs.virt-viewer
            ];
          };
        }
      );
    in
    {
      inherit
        formatter
        packages
        overlays
        nixosModules
        nixosConfigurations
        deploy
        devShells
        ;
    };
}
