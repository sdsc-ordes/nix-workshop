{
  description = "My Nix setup for Go";

  inputs = {
    devenv.url = "github:cachix/devenv";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or another channel
  };

  outputs = inputs: {
  };
}
