{
  config, # This is final set of devenv configuration options.
  pkgs,
  lib, # This is the `inputs.nixpkgs.lib` with handy functions.
  ...
}:
{
  packages = [
    pkgs.go
    pkgs.coreutils
    pkgs.findutils
    pkgs.just
    pkgs.git
  ];
}
