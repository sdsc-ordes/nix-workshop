{ pkgs, ... }:
{
  # options = { };

  # config = {
  # `config` can be omitted if toplevel `options` is not existing.

  packages = [
    pkgs.go
    pkgs.coreutils
    pkgs.findutils
    pkgs.just
    pkgs.git
  ];

  # };
}
