# Pulls the agenix module into every nixosSystem eval (identityPaths per host).
{ inputs, ... }:

{
  config.nixos.modules = [ inputs.agenix.nixosModules.default ];
}
