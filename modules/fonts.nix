# Fonts are installed only on hosts with a graphical user session; Ivaldi is
# intentionally left without the shared desktop package set.
{ ... }:

let
  fontPackages = pkgs: with pkgs; [ nerd-fonts.jetbrains-mono ];
in
{
  config.nixos.thor =
    { pkgs, ... }:
    {
      fonts.enableDefaultPackages = true;
      fonts.packages = fontPackages pkgs;
    };

  config.darwin.odin =
    { pkgs, ... }:
    {
      fonts.packages = fontPackages pkgs;
    };
}
