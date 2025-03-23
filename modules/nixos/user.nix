{
  config,
  pkgs,
  ...
}:
let
  settings = config.settings;
in
{
  ### User Settings ==========================================================
  programs.zsh.enable = true;

  users = {
    users.${settings.user.name} = {
      shell = pkgs.zsh;

      useDefaultShell = false;

      initialPassword = "nixos";
      isNormalUser = true;

      extraGroups = [
        "wheel"
        "disk"
        "libvirtd"
        "audio"
        "video"
        "input"
        "messagebus"
        "systemd-journal"
        "networkmanager"
        "network"
        "davfs2"
      ];

      # Extent the user `uid/gid` ranges to make podman work better.
      # This is for using https://gitlab.com/qontainers/pipglr
      subUidRanges = [
        {
          startUid = 100000;
          count = 65539;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65539;
        }
      ];
    };

  };
  # ===========================================================================
}
