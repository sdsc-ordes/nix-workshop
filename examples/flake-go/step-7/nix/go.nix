{
  config,
  lib,
  pkgs,
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

  enterShell =
    # bash
    ''
      echo "🐹 Running: $(${lib.getExe pkgs.go} version) 🐹"
    '';
}
