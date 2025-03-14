{
  lib,
  config,
  ...
}:
{
  ### Virtualisation ==========================================================

  # TODO: Somehow spice does not work: with `virt-viewer spice://localhost:5900`
  # services.xserver.videoDrivers = [ "qxl" ];
  # services.spice-vdagentd.enable = lib.mkForce true;
  # virtualisation.spiceUSBRedirection.enable = true;

  # ===========================================================================
}
