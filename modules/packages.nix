# Shared packages installed on both hosts. Ghostty differs per class:
# ghostty-bin is a darwin-only .dmg (fails to build on NixOS — modules/checks.nix
# guards against this), pkgs.ghostty is the source build for Linux. stow deploys
# dotfiles from the separate stow repo.
{ ... }:

let
  cliPackages =
    pkgs: with pkgs; [
      lsd
      fd
      ripgrep
      fzf
      zoxide
      fastfetch
      proton-pass-cli
      stow
      starship
    ];

  devPackages =
    pkgs: with pkgs; [
      nixd
      nixfmt

      pnpm
      nodejs

      git
    ];

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
      environment.systemPackages =
        cliPackages pkgs ++ devPackages pkgs ++ guiPackages pkgs ++ [ pkgs.ghostty ];
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages =
        cliPackages pkgs ++ devPackages pkgs ++ guiPackages pkgs ++ [ pkgs.ghostty-bin ];
    };
}
