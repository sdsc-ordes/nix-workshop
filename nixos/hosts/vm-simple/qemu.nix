{ ... }:
{
  virtualisation.cores = 8;
  virtualisation.memorySize = 5000;

  virtualisation.qemu = {
    options = [
      "-device virtio-gpu"
    ];
  };
}
