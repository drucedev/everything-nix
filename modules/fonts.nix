# fonts.packages exists on both classes; fonts.enableDefaultPackages is NixOS-only.
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
