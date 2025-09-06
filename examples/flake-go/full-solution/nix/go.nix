# We rely on a devenv  module to setup golang.
# This keeps the config simple, while setting up all the required tooling for vscode etc.
{ pkgs, ... }:
{
  packages = with pkgs; [
    coreutils
    curl
    fd
    findutils
    git
    just
  ];

  languages.go = {
    enable = true;
    package = pkgs.go;
  };

  env = {
    EXAMPLE_ENV_VAR = "MY_VALUE";
  };

  enterShell =
    # bash
    ''
      echo "🐹 Running: $(go version) 🐹"
    '';
}
