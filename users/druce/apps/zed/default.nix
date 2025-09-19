{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "catppuccin"
    ];
    extraPackages = with pkgs; [
      nil
      nixfmt
    ];
    userSettings = {
      auto_update = false;
      format_on_save = "on";
      keymap = "JetBrains";
      theme = "Catppuccin Mocha";
      editor = {
        font_family = "JetBrains Mono Nerd Font";
        font_size = 18;
        line_height = 1.5;
      };
      lsp = {
        nil = {
          settings = {
            formatting = {
              command = [ "nixfmt" ];
            };
            nix = {
              flake = {
                autoEvalInputs = true;
              };
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
            "!nixd"
            "nil"
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
