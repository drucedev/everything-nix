{ inputs, ... }:

{
  config.nixos.modules = [ inputs.agenix.nixosModules.default ];
}
