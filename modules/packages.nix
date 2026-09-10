# Single registry for user-facing packages. Ivaldi stays deliberately headless
# and gets nothing from here. Dotfiles are managed by the separate stow repo.
{ inputs, ... }:

let
  # Everyone on both workstations, delivered system-wide.
  sharedPackages =
    pkgs: with pkgs; [
      lsd
      fd
      ripgrep
      fzf
      curl
      tree-sitter
      (if stdenv.hostPlatform.isDarwin then clang else gcc)
      zoxide
      fastfetch
      proton-pass-cli
      cliamp
      stow
      starship
      mise
      python3
      gh
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
      discord
      xwayland-satellite
      xdg-user-dirs
      nautilus
      fuzzel
      grim
      slurp
      swaylock
      wl-clipboard
      awww
      vintagestory
      # pi coding agent from numtide/llm-agents while trying it out. The input
      # pins its own nixpkgs (no `follows`), so the package is referenced by
      # literal system; Thor is x86_64-linux per hosts.nix.
      inputs.llm-agents.packages.x86_64-linux.pi
    ];

  # System-wide on Odin: a launcher and a VPN tray are harmless for Liza, and
  # raycast needs Launch Services visibility. nodejs/pnpm stay Odin-only: Thor
  # dropped them once pi came from llm-agents.
  odinSystemApps =
    pkgs: with pkgs; [
      raycast
      proton-vpn
      nodejs
      pnpm
    ];

in
{
  config.nixos.thor =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedPackages pkgs ++ druceApps pkgs ++ thorExtraPackages pkgs;

      # Prebuilt llm-agents packages come from numtide's cache. Set system-wide
      # because a flake's nixConfig is only honored when interactively accepted
      # per command.
      nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
      nix.settings.extra-trusted-public-keys = [
        "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      ];
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
