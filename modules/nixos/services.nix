{
  config,
  pkgs,
  ...
}:
{
  ### Services ================================================================
  services = {
    # UDev settings.
    udev.packages = [
      pkgs.headsetcontrol
    ];

    # Dbus settings.
    dbus = {
      enable = true;
      # Choosing `broker` here uses
      # the new dbus implementation
      # which makes systemd units.
      implementation = "broker";
    };

    upower.enable = true;
    locate.enable = true;

    # Keyring Service
    gnome.gnome-keyring.enable = true;

    gvfs.enable = true; # Mount, trash, and other functionalities.
    tumbler.enable = true; # Thumbnailing DBus service.

    # Enable the OpenSSH daemon.
    openssh = {
      enable = false;
      ports = [ 50022 ];
      settings = {
        PermitRootLogin = "no";
        AllowUsers = [ config.settings.user.name ];
        PasswordAuthentication = true;
        KbdInteractiveAuthentication = true;
      };
    };
  };

  programs.dconf.enable = true;
  # ===========================================================================
}
