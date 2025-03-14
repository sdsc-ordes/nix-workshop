# My own settings to build the NixOS configurations.
{
  lib,
  config,
  ...
}:
let
  setts = config.settings;

  inherit (lib) mkOption types;
in
{
  options = {
    settings = {
      user = {
        name = mkOption {
          description = "The main user.";
          default = "nixos";
          type = types.str;
        };

        home = mkOption {
          description = "The home folder.";
          default = "/home/${setts.user.name}";
          type = types.oneOf [
            types.str
            types.path
          ];
        };

      };
    };
  };
}
