{
  lib,
  config,
  ...
}:
{
  ### Virtualisation ==========================================================
  users.users.${config.settings.user.name}.extraGroups = [
    "libvirtd"
  ];

  # Libvirtd ===============================
  boot.kernelModules = [
    "kvm-amd"
    "kvm-intel"
  ];

  # On Host systems we enable this (but not on guest os).
  services.qemuGuest.enable = true;

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
