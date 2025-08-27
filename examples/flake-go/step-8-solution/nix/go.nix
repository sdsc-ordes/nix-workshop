{ pkgsGo, ... }:
#
# Returning the devenv module function.
{
  lib,
  pkgs,
  ...
}:
{
  packages = [
    pkgsGo.go # <<<< Note here we use the passed `pkgsGo`.

    pkgs.coreutils
    pkgs.findutils
    pkgs.just
    pkgs.git
  ];

  # <<<< Note here we use `pkgsGo` as well.
  enterShell = ''
    echo "🐹 Running: $(${lib.getExe pkgsGo.go} version) 🐹"
  '';

}
