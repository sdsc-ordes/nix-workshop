{
  system ? builtins.currentSystem,
  pkgs ?
    # NixOS24.11
    import
      (fetchTarball "https://github.com/NixOS/nixpkgs/archive/5ef6c425980847c78a80d759abc476e941a9bf42.tar.gz")
      {
        inherit system;
      },
}:

# This is the most fundamental command in Nix:
derivation {
  name = "what-is-my-ip";
  builder = "/bin/sh";
  args = [
    "-c"
    ''
      ${pkgs.coreutils}/bin/mkdir -p $out/bin

      {
        echo '#!/bin/sh'
        echo '${pkgs.curl}/bin/curl -s http://ipinfo.io | \
        ${pkgs.jq}/bin/jq --raw-output .io'
      } > $out/bin/what-is-my-ip

      ${pkgs.coreutils}/bin/chmod +x $out/bin/what-is-my-ip
    ''
  ];

  system = builtins.currentSystem;
  outputs = [ "out" ];
}
