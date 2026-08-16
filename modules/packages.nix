# Single registry for user-facing packages. Ivaldi stays deliberately headless
# and gets nothing from here. Dotfiles are managed by the separate stow repo.
{ ... }:

let
  # Everyone on both workstations, delivered system-wide.
  sharedPackages =
    pkgs: with pkgs; [
      lsd
      fd
      ripgrep
      fzf
      zoxide
      fastfetch
      proton-pass-cli
      cliamp
      stow
      starship
      gh
      pnpm
      nodejs
      git
      brave
      btop
      neovim
    ];

  # Druce's GUI apps on both workstations: system-wide on Thor, per-user on
  # Odin so Liza keeps only the shared baseline. Ghostty is prebuilt on
  # darwin; the source build is heavy there.
  druceApps =
    pkgs: with pkgs; [
      zed-editor
      (if stdenv.hostPlatform.isDarwin then ghostty-bin else ghostty)
    ];

  # Desktop plumbing that only makes sense on Thor. herdr stays out of
  # sharedPackages: it does not exist on Odin's 26.05-darwin channel.
  thorExtraPackages =
    pkgs: with pkgs; [
      herdr
      xwayland-satellite
      xdg-user-dirs
      nautilus
      fuzzel
      grim
      slurp
      swaylock
      awww
    ];

  # System-wide on Odin: a launcher and a VPN tray are harmless for Liza, and
  # raycast needs Launch Services visibility.
  odinSystemApps =
    pkgs: with pkgs; [
      raycast
      proton-vpn
    ];

in
{
  config.nixos.thor =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedPackages pkgs ++ druceApps pkgs ++ thorExtraPackages pkgs;
    };

  config.darwin.odin =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedPackages pkgs ++ odinSystemApps pkgs;

      # Delivered per-user, so these leave /Applications/Nix Apps and
      # Launchpad; the dock pins in odin.nix reference store paths directly
      # and keep working.
      users.users.druce.packages = druceApps pkgs ++ [ pkgs.obsidian ];
    };
}
