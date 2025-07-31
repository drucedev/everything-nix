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
                };
            };
        };
    };
}
