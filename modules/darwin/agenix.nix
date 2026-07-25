# Pulls the agenix module into every darwinSystem eval (identityPaths per host).
{ inputs, ... }:

{
  config.darwin.modules = [ inputs.agenix.darwinModules.default ];
}
