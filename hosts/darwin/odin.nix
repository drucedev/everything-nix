{
  pkgs,
  vars,
  lib,
  ...
}:

{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  networking.hostName = "Odin";

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = builtins.elemAt vars.users 0;

  users.users = lib.genAttrs vars.users (name: {
    inherit name;
    home = "/Users/${name}";
    shell = "/bin/zsh";
  });

  environment.systemPackages = with pkgs; [
    brave
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.defaults = {
    dock.persistent-apps = [
      "${pkgs.brave}/Applications/Brave Browser.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
      "${pkgs.vscode}/Applications/Visual Studio Code.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
    ];
    dock.show-recents = false;

    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;

    loginwindow.GuestEnabled = false;

    finder.FXPreferredViewStyle = "clmv";
    finder.AppleShowAllExtensions = true;
  };
}
