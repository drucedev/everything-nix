# Cross-class nix config. Uses only options existing on BOTH NixOS and
# nix-darwin (nix-darwin lacks nix.gc.dates etc.), so one module serves both.
{ ... }:

let
  common =
    { ... }:
    {
      nix.settings.experimental-features = "nix-command flakes";

      nix.optimise.automatic = true;
    };
in
{
  config.nixos.base = common;
  config.darwin.base = common;
}
