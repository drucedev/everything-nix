{
  lib,
  ...
}:
let
  users = [
    "druce"
    "liza"
  ];
  primaryUser = builtins.elemAt users 0;
in
{
  networking.hostName = "Odin";

  system = {
    # Required for some settings like homebrew to know what user to apply to.
    inherit primaryUser;
    # Used for backwards compatibility, please read the changelog before changing.
    # $ darwin-rebuild changelog
    stateVersion = 6;
  };

  users.users = lib.genAttrs users (name: {
    inherit name;
    home = "/Users/${name}";
    shell = "/bin/zsh";
  });

  imports = [
    ./../../users/druce
    ./../../users/liza
  ];
}
