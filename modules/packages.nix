# Host-specific package sets. Keeping user-facing packages out of the shared
# bases keeps Ivaldi server-like while preserving Odin's existing package set.
# Dotfiles are managed by the separate stow repo.
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
      forgejo-cli
      gh
    ];

  devPackages =
    pkgs: with pkgs; [
      pnpm
      nodejs

      git
    ];

  guiPackages =
    pkgs: with pkgs; [
      brave
      zed-editor
    ];

  # Keep Thor focused on the dotfiles and coding baseline; broader CLI and
  # GUI tools remain available on Odin through the preserved package set.
  thorPackages =
    pkgs: with pkgs; [
      btop
      lsd
      fd
      ripgrep
      fzf
      zoxide
      fastfetch
      stow
      starship

      pnpm
      nodejs
      git

      ghostty
      brave
      zed-editor
      xwayland-satellite
      xdg-user-dirs
      nautilus
      fuzzel
      swaylock
    ];

in
{
  config.nixos.thor =
    { pkgs, ... }:
    {
      environment.systemPackages = thorPackages pkgs;
    };

  # Preserve Odin's previous shared package set while keeping it out of Ivaldi.
  config.darwin.odin =
    { pkgs, ... }:
    {
      environment.systemPackages =
        cliPackages pkgs
        ++ devPackages pkgs
        ++ guiPackages pkgs
        ++ [
          pkgs.btop
          pkgs.ghostty-bin
        ];
    };
}
