# Cross-class nix config. Uses only options existing on BOTH NixOS and
# nix-darwin (nix-darwin lacks nix.gc.dates etc.), so one module serves both.
{ ... }:

let
  common =
    { ... }:
    {
      # Newer nixpkgs types experimental-features strictly as a list of strings.
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.optimise.automatic = true;
    };
in
{
  config.nixos.base = common;
  config.darwin.base = common;
}
