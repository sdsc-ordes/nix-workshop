{
  pkgs,
  inputs,
  ...
}:
{
  ### Keyboard Settings =================================================
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
  # ===========================================================================
}
