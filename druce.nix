{ config, pkgs, ... }:

{
    programs.vscode = {
        enable = true;
        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                jnoortheen.nix-ide
            ];
            userSettings {
                "nix.enableLanguageServer" = true;
                "nix.serverPath" = "nil";
            };
        };
    };

    home.packages = with pkgs; [
        nil
    ];
}