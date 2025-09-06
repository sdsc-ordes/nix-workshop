{
  lib,
  pkgs,
  ...
}:
{
  # Lets you import other modules.
  imports = [
    # TODO
  ];

  config = {
    packages = [
      pkgs.go
      pkgs.coreutils
      pkgs.findutils
      pkgs.just
      pkgs.git
    ];

    env = {
      EXAMPLE_ENV_VAR = "MY_VALUE";
    };

    enterShell =
      # bash
      ''
        echo "🐹 Running: $(${lib.getExe pkgs.go} version) 🐹"
      '';
  };
}
