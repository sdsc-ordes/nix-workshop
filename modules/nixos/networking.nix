{
  config,
  pkgs,
  ...
}:
{
  networking = {
    ### Networking ==============================================================
    hostName = "linux-nixos"; # Define your hostname.
    networkmanager.enable = true;

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    # interfaces.enp4s0.useDHCP = true;
    # interfaces.wlp3s0.useDHCP = true;
    # ===========================================================================

    ### Firewall ================================================================
    # Open ports in the firewall.
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    # ===========================================================================
  };
}
