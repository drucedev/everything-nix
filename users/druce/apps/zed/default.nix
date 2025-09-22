{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "catppuccin"
    ];
    extraPackages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
    userSettings = {
      auto_update = false;
      format_on_save = "on";
      keymap = "JetBrains";
      theme = "Catppuccin Mocha";
      editor = {
        font_family = "JetBrains Mono Nerd Font";
        font_size = 20;
        line_height = 1.5;
      };
      lsp = {
        nixd = {
          settings = {
            formatting = {
              command = [ "nixfmt" ];
            };
            nixpkgs = {
              expr = ''import <nixpkgs> { }'';
            };
          };
        };
      };
      languages = {
        Nix = {
          formatter = {
            external = {
              command = "nixfmt";
            };
          };
          language_servers = [
            "nixd"
            "!nil"
          ];
        };
      };
      telemetry = {
        metrics = false;
        crash_reports = false;
      };
    };
  };
}
