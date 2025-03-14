{
  config,
  pkgs,
  ...
}:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.autorun = true;

  # Display Manager ===========================================================
  services.displayManager = {
    autoLogin.enable = false;
    autoLogin.user = "nixos";
  };

  services.xserver.displayManager = {
    gdm = {
      enable = true;
      wayland = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
  # ===========================================================================

  # Desktop Manager ===========================================================
  services.xserver.desktopManager.gnome.enable = true;
  # ===========================================================================

  # To make screencasting work in Chrome and other Apps communicating
  # over DBus.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
      pkgs.xdg-desktop-portal-gtk
    ];
  };

}
