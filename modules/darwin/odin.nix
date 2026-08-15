# Odin — nix-darwin host (x86_64-darwin, stable nixpkgs): identity + unique
# settings. hosts.nix composes darwin.base alongside; druce comes from
# users/druce.nix. The config is a function so darwinSystem injects `pkgs`.
{
  lib,
  ...
}:

{
  options.darwin.odin = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config.darwin.odin =
    { pkgs, ... }:
    {
      networking.hostName = "Odin";

      system.primaryUser = "druce";
      system.stateVersion = 6;

      # Odin's age key; generate: sudo age-keygen -o /etc/age/age-key (pubkey -> secrets.nix).
      # Must be root-readable (darwin activation runs as root).
      age.identityPaths = [ "/etc/age/age-key" ];

      # Per-project devshells enter via `use flake` .envrc files.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # Odin-specific apps; the preserved shared package set comes from packages.nix.
      environment.systemPackages = with pkgs; [
        proton-vpn
        obsidian
        raycast
      ];

      # Liza — login user on Odin only.
      users.users.liza = {
        name = "liza";
        home = "/Users/liza";
        shell = "/bin/zsh";
      };

      system.defaults = {
        dock.show-recents = false;
        dock.persistent-apps = [
          "${pkgs.brave}/Applications/Brave Browser.app"
          "${pkgs.ghostty-bin}/Applications/Ghostty.app"
          "${pkgs.zed-editor}/Applications/Zed.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
        ];

        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain."com.apple.keyboard.fnState" = true;

        loginwindow.GuestEnabled = false;

        finder.FXPreferredViewStyle = "clmv";
        finder.AppleShowAllExtensions = true;
      };
    };
}
