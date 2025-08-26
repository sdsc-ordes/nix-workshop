{
  lib,
  pkgs,
  ...
}:
{
  # Lets you import other modules.
  imports = [
    ./module-run-script.nix
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

    enterShell = ''
      echo "🐹 Running: $(${lib.getExe pkgs.go} version) 🐹"
    '';

    # Enable the run script.
    # This option is available since we imported the module which defines it
    # above.
    nix-workshop.run-script.enable = true;
  };
}
