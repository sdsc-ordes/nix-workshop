{ pkgs, rootDir, ... }:
let
  # This is equivalent to `goSrc = rootDir + "/src` but the
  # [`fileset`](https://noogle.dev/q?term=lib.fileset) library gives more
  # flexibility to construct source derivations used
  # in the below build support function `buildGoModule`.
  goSrc = pkgs.lib.fileset.toSource {
    root = rootDir + "/src";
    fileset = pkgs.lib.fileset.gitTracked (rootDir + "/src");
  };

  default = pkgs.buildGoModule {
    name = "demo";
    version = "0.1.0";
    src = goSrc;

    modRoot = ".";
    vendorHash = "sha256-Nm5G4bEFwgA2+5Octhn2s6vquNtwQ82Z4bevZ5R20vU=";
  };

  image = pkgs.dockerTools.buildLayeredImage {
    name = "demo";
    tag = "latest";

    contents = [ default ];

    config = {
      Cmd = [ "/bin/demo" ];
    };
  };
in
{
  inherit default image;
}
