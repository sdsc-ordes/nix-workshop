{
  pkgs,
  func,
}: let
  supportedSystems = [
    "aarch64-darwin"
    "aarch64-linux"
    "x86_64-darwin"
    "x86_64-linux"
  ];
in
  pkgs.lib.genAttrs supportedSystems (system:
    func {
      pkgs = import pkgs {inherit system;};
    })
