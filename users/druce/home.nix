{ pkgs, ... }:

{
  home = {
    stateVersion = "25.05";

    username = "druce";
    homeDirectory = "/Users/druce";

    shell.enableZshIntegration = true;

    file.".config/BraveSoftware/Brave-Browser/Default/Preferences".text = builtins.toJSON {
      brave.update.enabled = false;
    };

    packages = with pkgs; [
      nixd
      nixfmt
      raycast
    ];
  };

  programs = {
    zsh = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = pkgs.lib.importTOML ./starship.toml;
    };

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    obsidian = {
      enable = true;
    };

    zed-editor = {
      enable = true;
      extensions = [
        "nix"
        "catppuccin"
      ];
      extraPackages = with pkgs; [
        nixd
        nixfmt
      ];
      userSettings = builtins.fromJSON (builtins.readFile ./zed-settings.json);
    };
  };
}
