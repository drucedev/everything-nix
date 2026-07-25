# Odin — nix-darwin host (x86_64-darwin, stable nixpkgs): identity + unique
# settings. hosts.nix composes darwin.base and the users alongside. The config
# is a function so darwinSystem injects `pkgs`.
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

      # Odin-specific; shared apps come from packages/*.nix via base.
      environment.systemPackages = with pkgs; [
        proton-vpn
        obsidian
        raycast
      ];

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
