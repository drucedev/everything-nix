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
      theme = "Catppuccin Mocha";
      base_keymap = "JetBrains";

      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 18;

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
        YAML = {
          tab_size = 2;
        };
      };
      telemetry = {
        metrics = false;
        diagnostics = false;
      };
    };
  };
}
