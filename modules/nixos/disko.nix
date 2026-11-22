{ inputs, ... }:

{
  config.nixos.modules = [ inputs.disko.nixosModules.disko ];
}
