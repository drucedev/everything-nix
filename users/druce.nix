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
      nil
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

    vscode = {
      enable = true;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          tamasfe.even-better-toml
        ];
        userSettings = builtins.fromJSON (builtins.readFile ./vscode-settings.json);
      };
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
