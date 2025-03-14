{ config, ... }:
{
  users.users.${config.settings.user.name}.extraGroups = [
    "docker"
    "podman"
  ];

  # Docker =================================
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    rootless = {
      enable = false;
      setSocketVariable = true;
    };

    # Auto prune docker resources.
    autoPrune = {
      dates = "weekly";
      flags = [ "--external" ];
    };
  };
  # =======================================

  # Podman ================================
  virtualisation.podman = {
    enable = true;

    # Create a `docker` alias for podman, to use it as a drop-in replacement
    # dockerCompat = true;
    # dockerSocket = {
    #   enable = true;
    # };

    # Required for containers under podman-compose to be able to talk to each other.
    defaultNetwork.settings.dns_enabled = true;

    # Auto prune podman resources.
    autoPrune = {
      dates = "weekly";
      flags = [ "--external" ];
    };
  };
  # =======================================
}
