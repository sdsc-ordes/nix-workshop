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
    ''
      echo "🐹 Running: $(${lib.getExe pkgs.go} version) 🐹"
    ''
    + (
      if config.dotenv.enable then
        ''
          echo "✅ Dotenv enabled: loaded '${config.dotenv.filename}'."
        ''
      else
        ''echo "❌ Dotenv loading disabled."''
    )
  );

}
