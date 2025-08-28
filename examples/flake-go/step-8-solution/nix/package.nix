{
  pkgs,
  rootDir,
  ...
}:
pkgs.buildGoModule {
  name = "demo";
  version = "0.1.0";
  src = rootDir + "/src";

  modRoot = ".";
  vendorHash = "sha256-Nm5G4bEFwgA2+5Octhn2s6vquNtwQ82Z4bevZ5R20vU=";
}
