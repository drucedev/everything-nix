# Single registry for user-facing packages. Dotfiles are managed by the
# separate stow repo. Ivaldi gets the CLI baseline plus agent tools; GUI apps
# stay on the workstations.
{ inputs, ... }:

let
  # CLI tools shared by the workstations and Ivaldi.
  sharedCli =
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
      nodejs_24
      gnumake
      jq
      gh
      git
      btop
      neovim
    ];

  # Everyone on both workstations, delivered system-wide.
  sharedPackages = pkgs: sharedCli pkgs ++ [ pkgs.brave ];

  # Headless agent host. `t3` is the server CLI, not the Electron app.
  # The wrapper only puts provider CLIs on `t3`'s own PATH; login shells and
  # the user service `t3 service install` writes need them on the system PATH.
  ivaldiAgentPackages =
    pkgs:
    let
      ai = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      t3 = ai.t3code;
    in
    [
      ai.pi
      ai.open-code-review
      t3
      pkgs.age
      pkgs.tmux
      pkgs.unzip
    ]
    ++ t3.providerPackages;

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
    pkgs:
    let
      ai = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    with pkgs;
    [
      discord
      xwayland-satellite
      xdg-user-dirs
      nautilus
      fuzzel
      quickshell
      grim
      slurp
      swaylock
      wl-clipboard
      awww
      vintagestory
      ai.pi
      ai.herdr
      ai.hunk
      ai.open-code-review
      ai.t3code-desktop
    ];

  # System-wide on Odin: a launcher and a VPN tray are harmless for Liza, and
  # raycast needs Launch Services visibility. pnpm stays Odin-only.
  odinSystemApps =
    pkgs: with pkgs; [
      raycast
      proton-vpn
      pnpm
    ];

in
{
  config.nixos.thor =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedPackages pkgs ++ druceApps pkgs ++ thorExtraPackages pkgs;
    };

  config.nixos.ivaldi =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedCli pkgs ++ ivaldiAgentPackages pkgs;
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
