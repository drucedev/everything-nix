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

      nixd
      nixfmt
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
          (jbrsdk pkgs)
        ];
    };
}
