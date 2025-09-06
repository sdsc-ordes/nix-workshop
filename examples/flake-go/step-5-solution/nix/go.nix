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

  env = {
    EXAMPLE_ENV_VAR = "MY_VALUE";
  };

  enterShell = (
    # bash
    ''
      echo "🐹 Running: $(${lib.getExe pkgs.go} version) 🐹"
    ''
    + (
      if config.dotenv.enable then
        # bash
        ''
          echo "✅ Dotenv enabled: loaded '${config.dotenv.filename}'."
        ''
      else
        # bash
        ''echo "❌ Dotenv loading disabled."''
    )
  );

}
