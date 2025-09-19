{ ... }:

{
  home.shell.enableZshIntegration = true;

  programs = {
    zsh = {
      enable = true;
    };
  };

  imports = [
    ./prompt
  ];
}
