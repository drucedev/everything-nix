# Odin — the nix-darwin host (x86_64-darwin, stable nixpkgs). Holds Odin's
# identity + unique settings ONLY; the reusable `darwin.base` is imported
# alongside this by modules/hosts.nix (not composed here), so both apply to the
# system and merge naturally in the darwin eval. Users come from
# modules/users/{druce,liza}.nix (imported by hosts.nix), so no `users.users` is
# declared here.
#
# The config block is a FUNCTION `{ pkgs, ... }:` (not a bare attrset) so that
# `pkgs` is injected by darwinSystem at import time — flake-parts does not
# provide `pkgs` at the top-level module scope.
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

      # Odin-specific packages. brave/wezterm/zed-editor come from
      # modules/packages/gui.nix via base; CLI/dev tools from cli.nix/dev.nix.
      environment.systemPackages = with pkgs; [
        proton-vpn
        obsidian
        jetbrains-toolbox
        raycast
      ];

      system.defaults = {
        dock.show-recents = false;
        dock.persistent-apps = [
          "${pkgs.brave}/Applications/Brave Browser.app"
          "${pkgs.wezterm}/Applications/WezTerm.app"
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
