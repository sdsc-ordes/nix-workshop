{ ... }:
{
  virtualisation.qemu.options = [
    "-device virtio-gpu"
    "-display gtk,gl=on"
    # "-spice port=5900,addr=127.0.0.1,disable-ticketing=on"
    # "-device qxl"
  ];
}
