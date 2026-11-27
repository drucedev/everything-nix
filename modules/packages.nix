{ inputs, ... }:

let
  sharedCli =
    pkgs: with pkgs; [
      bat
      lsd
      fd
      ripgrep
      fzf
      curl
      ffmpeg
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
      nodejs_24
      gnumake
      jq
      gh
      git
      btop
      neovim
    ];

  agentTools =
    pkgs:
    let
      ai = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    [
      ai.pi
      ai.claude-code
      ai.codex
      ai.open-code-review
    ];

  t3codeWithTranscription =
    pkgs:
    let
      system = pkgs.stdenv.hostPlatform.system;
      t3 = inputs.llm-agents.packages.${system}.t3code;
      pnpmStore = "$out/libexec/t3code/apps/server/node_modules/.pnpm";
    in
    t3.override {
      t3code-unwrapped = t3.unwrapped.overrideAttrs (old: {
        buildInputs = old.buildInputs ++ [
          inputs.llm-agents.inputs.nixpkgs.legacyPackages.${system}.vulkan-loader
        ];
        postFixup = old.postFixup + ''
          speechLibs=(
            ${pnpmStore}/@koromix+koffi-linux-x64@*/node_modules/@koromix/koffi-linux-x64/linux_x64
            ${pnpmStore}/@transcribe-cpp+linux-x64-cpu-vulkan@*/node_modules/@transcribe-cpp/linux-x64-cpu-vulkan
          )
          for dir in "''${speechLibs[@]}"; do test -d "$dir"; done
          autoPatchelf "''${speechLibs[@]}"
        '';
      });
    };

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
      brave
      discord
      xwayland-satellite
      xdg-user-dirs
      nautilus
      fuzzel
      quickshell
      swaylock
      wl-clipboard
      awww
      vintagestory
      ai.grok-bot
      ai.beads
      ai.beads-viewer
      (ai.t3code-desktop.override { t3code = t3codeWithTranscription pkgs; })
    ]
    ++ agentTools pkgs;

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
      environment.systemPackages = sharedCli pkgs ++ druceApps pkgs ++ thorExtraPackages pkgs;
    };

  config.nixos.ivaldi =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedCli pkgs ++ ivaldiAgentPackages pkgs;
    };

  config.darwin.odin =
    { pkgs, ... }:
    {
      environment.systemPackages = sharedCli pkgs ++ odinSystemApps pkgs;
      users.users.druce.packages = druceApps pkgs ++ [ pkgs.obsidian ];
    };
}
