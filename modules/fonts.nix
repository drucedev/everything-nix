# Fonts. `fonts.packages` exists on both NixOS and nix-darwin and is shared.
# `fonts.enableDefaultPackages` is NixOS-only, so it goes on the NixOS base.
{ ... }:

let
  fontPackages = pkgs: with pkgs; [ nerd-fonts.jetbrains-mono ];
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      fonts.enableDefaultPackages = true;
      fonts.packages = fontPackages pkgs;
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      fonts.packages = fontPackages pkgs;
    };
}
