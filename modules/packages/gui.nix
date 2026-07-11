# Shared GUI applications installed on both hosts.
{ ... }:

let
  guiPackages =
    pkgs: with pkgs; [
      brave
      wezterm
      zed-editor
      ghostty-bin
    ];
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = guiPackages pkgs;
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = guiPackages pkgs;
    };
}
