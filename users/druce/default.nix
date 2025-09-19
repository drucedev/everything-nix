{ pkgs, ... }:

{
  system.defaults = {
    dock.persistent-apps = [
      "${pkgs.brave}/Applications/Brave Browser.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
      "${pkgs.zed-editor}/Applications/Zed.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
    ];
  };

  home-manager.users."druce" = ./home.nix;
}
