{ pkgs, config, ... }:
let
  settings = config.settings;
in
{
  # We define no new options (NixOS module system.)
  options = { };

  config = {
    # Here we define our full system.
    console = {
      keyMap = "us";
    };

    virtualization.graphics = false;

    programs.zsh.enable = true;

    users = {
      users.${settings.user.name} = {
        shell = pkgs.zsh;

        useDefaultShell = false;

        initialPassword = "nixos";
        isNormalUser = true;
      };
    };
  };
}
