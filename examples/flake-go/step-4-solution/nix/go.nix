{ pkgs, ... }:
{
  packages = [
    pkgs.go
    pkgs.coreutils
    pkgs.findutils
    pkgs.just
    pkgs.git
  ];
}
