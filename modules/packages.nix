# Single registry for user-facing packages; dotfiles live in the stow repo.
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

  # transcribe-cpp's prebuilt koffi and ggml libraries cannot resolve
  # libstdc++ or libvulkan, breaking local speech; patch them as upstream
  # patches node-pty. Libraries come from llm-agents' nixpkgs so one glibc
  # is loaded. The desktop output reuses this server tree via a symlink.
  t3code =
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

  # `t3` only puts provider CLIs on its own PATH; shells and the
  # `t3 service install` unit need them system-wide.
  ivaldiAgentPackages =
    pkgs:
    let
      t3 = t3code pkgs;
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
      (ai.t3code-desktop.override { t3code = t3code pkgs; })
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

      # Per-user apps leave /Applications/Nix Apps; dock pins use store paths.
      users.users.druce.packages = druceApps pkgs ++ [ pkgs.obsidian ];
    };
}
