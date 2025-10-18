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
      nixd
      nixfmt-rfc-style
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv.enable = true;
      stdlib = ''
          unset NIX_PATH

          : ''${XDG_CACHE_HOME:=$HOME/.cache}
          declare -A direnv_layout_dirs
          direnv_layout_dir() {
           	echo "''${direnv_layout_dirs[$PWD]:=$(
          		echo -n "$XDG_CACHE_HOME"/direnv/layouts/
          		echo -n "$PWD" | sha1sum | cut -d ' ' -f 1
           	)}"
          }
      '';
    };
  };
}
