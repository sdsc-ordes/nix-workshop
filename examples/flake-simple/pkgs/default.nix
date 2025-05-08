{ pkgs, ... }:
{
  mytool = pkgs.writeShellScriptBin "mytool" ''
    "${pkgs.cowsay}/bin/cowsay" "Hello there ;)"
    echo "-------------------------------------"
    "${pkgs.figlet}/bin/figlet" "Do you expect"
    "${pkgs.figlet}/bin/figlet" "something "
    "${pkgs.figlet}/bin/figlet" "useful ? "
  '';
}
