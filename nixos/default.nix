{
  inputs,
  outputs,
  ...
}:
{
  vm-simple = import ./hosts/vm-simple { inherit inputs outputs; };
  vm = import ./hosts/vm { inherit inputs outputs; };
}
