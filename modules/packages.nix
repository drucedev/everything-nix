# Shared packages installed on both hosts. Ghostty differs per class:
# ghostty-bin is a darwin-only .dmg (fails to build on NixOS — modules/checks.nix
# guards against this), pkgs.ghostty is the source build for Linux. Same for the
# JDK: nixpkgs' JBR build is source-only and Linux-only, so Odin wraps
# JetBrains' official jbrsdk binary (below). stow deploys dotfiles from the
# separate stow repo.
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

  # KMP needs JBR 25 with JetBrains' patches. nixpkgs' jetbrains.jdk builds
  # from source via Linux-only scripts (broken on darwin), but JetBrains still
  # publishes official osx-x64 binaries — wrap jbrsdk, the full JDK.
  jbrsdk =
    pkgs:
    pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
      pname = "jbrsdk";
      version = "25.0.3-b508.16";

      src = pkgs.fetchurl {
        url = "https://cache-redirector.jetbrains.com/intellij-jbr/jbrsdk-25.0.3-osx-x64-b508.16.tar.gz";
        hash = "sha256-cKMxc8ywAYInO5zLZX/9VeHf+1wB7Q6YEKw0Pauzsmo=";
      };

      # Signed Mach-O binaries; stripping would invalidate signatures.
      dontStrip = true;

      # Tarball has macOS bundle layout; Contents/Home is the JDK home.
      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R Contents/Home/. $out/
        runHook postInstall
      '';

      passthru.home = finalAttrs.finalPackage;

      meta = with pkgs.lib; {
        description = "JetBrains Runtime SDK (official binary) — OpenJDK with JetBrains patches";
        homepage = "https://github.com/JetBrains/JetBrainsRuntime";
        license = pkgs.jdk.meta.license;
        platforms = [ "x86_64-darwin" ];
        mainProgram = "java";
      };
    });
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages =
        cliPackages pkgs
        ++ devPackages pkgs
        ++ guiPackages pkgs
        ++ [
          pkgs.ghostty
          pkgs.jetbrains.jdk
        ];
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages =
        cliPackages pkgs
        ++ devPackages pkgs
        ++ guiPackages pkgs
        ++ [
          pkgs.ghostty-bin
          (jbrsdk pkgs)
        ];
    };
}
