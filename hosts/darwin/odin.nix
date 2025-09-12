{
  vars,
  lib,
  ...
}:
let
  druce = builtins.elemAt vars.users 0;
in
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  networking.hostName = "Odin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = druce;

  users.users = lib.genAttrs vars.users (name: {
    inherit name;
    home = "/Users/${name}";
    shell = "/bin/zsh";
  });

  imports = [
    ./../../users/druce
  ];
}
