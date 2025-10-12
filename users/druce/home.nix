{ pkgs, ... }:

{
  home = {
    stateVersion = "25.05";

    username = "druce";
    homeDirectory = "/Users/druce";

    file.".config/BraveSoftware/Brave-Browser/Default/Preferences".text = builtins.toJSON {
      brave.update.enabled = false;
    };

    packages = with pkgs; [
      raycast
      lsd
      jetbrains-toolbox
    ];
  };

  imports = [
    ./apps/shell
    ./apps/zed
    ./apps/wezterm
  ];

  programs = {
    obsidian = {
      enable = true;
    };
  };
}
