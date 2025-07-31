{ pkgs, ... }:

{
    home = {
       stateVersion = "25.05";

       username = "druce";
       homeDirectory = "/Users/druce";

       shell.enableZshIntegration = true;

       packages = with pkgs; [
        nil
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
            extraConfig = ''
                local wezterm = require("wezterm")

                local config = wezterm.config_builder()

                config.font_size = 16

                config.color_scheme = 'Catppuccin Mocha'

                config.window_background_opacity = 0.85
                config.macos_window_background_blur = 5
                config.native_macos_fullscreen_mode = true

                return config
            '';
        };

        vscode = {
            enable = true;
            profiles.default = {
                extensions = with pkgs.vscode-extensions; [
                    jnoortheen.nix-ide
                    tamasfe.even-better-toml
                ];
                userSettings = {
                    "nix.enableLanguageServer" = true;
                    "nix.serverPath" = "nil";
                    "git.enableSmartCommit" = true;
                };
            };
        };
    };
}
