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
        raycast
       ];
    };

    system.defaults = {
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleShowAllExtensions = true;
        loginwindow.GuestEnabled = false;
        finder.FXPreferredViewStyle = "clmv";
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
                userSettings = {
                    "nix.enableLanguageServer" = true;
                    "nix.serverPath" = "nil";
                    "git.enableSmartCommit" = true;
                    "update.mode" = "none";
                };
            };
        };
    };
}
