{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Declare new options here.
  options = {
    # You can create modules with only this option
    # which lets you customize behavior on top.
    # This `run-script` options should enable a `script`
    # which runs over `go run`.
    nix-workshop.run-script = {
    };
  };

  # Implement the new option.
  config = {
    # Define a `devenv` script `run-it`
    # But enable it only when `nix-workshop.run-script.enable == true`.
    scripts.run-it = {
    };
  };
}
