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
