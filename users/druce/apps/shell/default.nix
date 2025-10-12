{ ... }:

{
  home.shell.enableZshIntegration = true;

  programs = {
    zsh = {
      enable = true;
      shellAliases = {
        ls = "lsd";
        ll = "lsd -l";
        la = "lsd -la";
      };
    };
  };

  imports = [
    ./prompt
  ];
}
