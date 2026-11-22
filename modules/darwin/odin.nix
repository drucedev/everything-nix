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

      age.identityPaths = [ "/etc/age/age-key" ];

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      users.users.liza = {
        name = "liza";
        home = "/Users/liza";
        shell = "/bin/zsh";
      };

      system.defaults = {
        dock.show-recents = false;
        dock.persistent-apps = [
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
