# Shared GUI apps. Ghostty differs per class: ghostty-bin is a darwin-only
# .dmg (fails to build on NixOS — modules/checks.nix guards against this),
# pkgs.ghostty is the source build for Linux.
{ ... }:

let
  guiPackages =
    pkgs: with pkgs; [
      brave
      zed-editor
    ];
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = guiPackages pkgs ++ [ pkgs.ghostty ];
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = guiPackages pkgs ++ [ pkgs.ghostty-bin ];
    };
}
