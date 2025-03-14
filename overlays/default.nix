# This file defines overlays
{ inputs, ... }:
let
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: {
    additions = import ../pkgs {
      inherit inputs;
      pkgs = final;
    };
  };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev: { };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable = final: _prev: {
    # Import nixpkgs (the unstable input).
    unstable = import inputs.nixpkgsUnstable {
      overlays = [ modifications ];
      system = final.system;
      config.allowUnfree = true;
    };
  };
in
{
  # Overlays are very useful to overwrite a package globally which then gets used transitively.
  # So overlays should only be used when a package must be overwritten for all
  # packages which might need to use this derivation override as well.
  #
  # [Read more here](docs/pass-inputs-to-modules.md) and
  # [here](https://nix-community.github.io/home-manager/options.xhtml#opt-nixpkgs.overlays).

  inherit additions;
  inherit modifications;
  inherit unstable;
}
