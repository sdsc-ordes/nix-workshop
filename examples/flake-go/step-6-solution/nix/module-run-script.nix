{
  config,
  lib,
  pkgs,
  ...
}:
let
  # A shortcut to the final option we declare in `options` below.
  cfg = config.nix-workshop.run-script;
in
{

  # Declare new options here.
  options = {
    # You can create modules with only this option
    # which lets you customize behavior on top.
    # This `run-script` options enables a `script`
    # which contains the build. This a bit meaningless, but only
    # here for demonstration purposes.
    nix-workshop.run-script = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable the run script `run-it`.";
      };

      path = lib.mkOption {
        type = lib.types.str;
        default = "./src/main.go";
        description = "The path to the Go file to run.";
      };
    };
  };

  # Implement the new option.
  config = {

    # Define a `devenv` script `run-it`
    # But enable it only with `lib.mkIf <condition>`.
    scripts.run-it = lib.mkIf cfg.enable {
      exec = ''
        echo "❤️‍🔥 Running main application '${cfg.path}"
        ${lib.getExe pkgs.go} run ${cfg.path}
      '';
    };

  };
}
