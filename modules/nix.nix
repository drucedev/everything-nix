# Cross-class nix config. Uses only options existing on BOTH NixOS and
# nix-darwin (nix-darwin lacks nix.gc.dates etc.), so one module serves both.
{ ... }:

let
  common =
    { ... }:
    {
      nix.settings = {
        substituters = [ "https://cache.nixos.org/" ];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        experimental-features = "nix-command flakes";
        fallback = true;
        max-jobs = "auto";
      };

      nix.optimise.automatic = true;

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

    };
in
{
  config.nixos.base = common;
  config.darwin.base = common;
}
