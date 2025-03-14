{
  config,
  ...
}:
{
  ### Virtualisation ==========================================================
  users.users.${config.settings.user.name}.extraGroups = [
    "libvirtd"
  ];

  # Libvirtd ===============================
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      ovmf.enable = true;
      runAsRoot = true;
    };
    onBoot = "ignore";
    onShutdown = "shutdown";
  };
  # ========================================

  # ===========================================================================
}
