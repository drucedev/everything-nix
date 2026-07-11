# Cross-class nix configuration. `nix.settings`, `nix.optimise.automatic` and
# `nix.gc` (using only `automatic` + `options`, which exist on BOTH NixOS and
# nix-darwin — nix-darwin removed `dates`/`randomizedDelaySec`/`persistent`/
# `user`, but this config uses none of those) are identical across both classes,
# so a single `common` module is assigned to both bases.
{ ... }:

let
  common =
    { pkgs, ... }:
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

      environment.systemPackages = with pkgs; [ btop ];
    };
in
{
  config.nixos.base = common;
  config.darwin.base = common;
}
