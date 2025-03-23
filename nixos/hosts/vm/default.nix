{
  inputs,
  outputs,
  ...
}:
# The NixOS VM running on a stable nixpkgs branch.
inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    ./configuration.nix
  ];
  specialArgs = {
    inherit inputs outputs;
  };
}
