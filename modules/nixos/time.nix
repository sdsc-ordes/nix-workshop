{
  config,
  pkgs,
  ...
}:
{
  # Set time by a systemd daemon which get location information from geoclue.
  services.localtimed.enable = true;
  services.geoclue2 = {
    enable = true;
    enableWifi = true;
  };
}
