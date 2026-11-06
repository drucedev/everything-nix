# Single registry for user-facing packages; dotfiles live in the stow repo.
{ inputs, ... }:

let
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

  sharedPackages = pkgs: sharedCli pkgs ++ [ pkgs.brave ];

  # Linux only: llm-agents has no x86_64-darwin builds.
  agentTools =
    pkgs:
    let
      ai = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    [
      ai.pi
      ai.claude-code
      ai.open-code-review
    ];

  # `t3` only puts provider CLIs on its own PATH; shells and the
  # `t3 service install` unit need them system-wide.
  ivaldiAgentPackages =
    pkgs:
    let
      t3 = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.t3code;
    in
    agentTools pkgs
    ++ [
      t3
      pkgs.age
      pkgs.tmux
      pkgs.unzip
    ]
    ++ t3.providerPackages;

  # Per-user on Odin so Liza keeps only the shared baseline. ghostty-bin
  # avoids a heavy source build on darwin.
  druceApps =
    pkgs: with pkgs; [
      zed-editor
      (if stdenv.hostPlatform.isDarwin then ghostty-bin else ghostty)
    ];

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
      ai.t3code-desktop
    ]
    ++ agentTools pkgs;

  # System-wide: raycast needs Launch Services visibility.
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

      # Per-user apps leave /Applications/Nix Apps; dock pins use store paths.
      users.users.druce.packages = druceApps pkgs ++ [ pkgs.obsidian ];
    };
}
