{ pkgs, ... }:

{
  home = {
    stateVersion = "25.05";

    username = "druce";
    homeDirectory = "/home/druce";
  };

  imports = [
    ./../../../users/druce/apps/zed
  ];
}
