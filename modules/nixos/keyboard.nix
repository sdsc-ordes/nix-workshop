{
  pkgs,
  inputs,
  ...
}:
{
  ### Keyboard Settings =================================================

  # Waylands input service which handles mouse and touchpad.
  services.libinput = {
    enable = true;
    touchpad = {
      tapping = true;
      tappingButtonMap = "lrm";
      naturalScrolling = true;
      horizontalScrolling = true;
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "us";
  };

  services.xserver = {
    xkb = {
      layout = "programmer";
      variant = "";
      options = "ctrl:nocaps";

      extraLayouts.programmer = {
        description = "Programmer (US)";
        languages = [ "eng" ];
        symbolsFile = inputs.self + "/config/keyboard/symbols/programmer";
      };
    };
  };

  # Logitech Receiver and Solaar Gui
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  environment.systemPackages = with pkgs; [
    solaar
  ];

  # ===========================================================================
}
