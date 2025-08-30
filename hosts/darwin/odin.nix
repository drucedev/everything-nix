{ pkgs, ... }:

{
  networking.hostName = "Odin";

  users.users.druce = {
    name = "druce";
    home = "/Users/druce";
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    brave
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  # Required for some settings like homebrew to know what user to apply to.
  system.primaryUser = "druce";

  system.defaults = {
    dock.persistent-apps = [
      "${pkgs.brave}/Applications/Brave Browser.app"
      "${pkgs.wezterm}/Applications/WezTerm.app"
      "${pkgs.vscode}/Applications/Visual Studio Code.app"
      "${pkgs.obsidian}/Applications/Obsidian.app"
    ];
    dock.show-recents = false;

    NSGlobalDomain.AppleICUForce24HourTime = true;

    loginwindow.GuestEnabled = false;

    finder.FXPreferredViewStyle = "clmv";
    finder.AppleShowAllExtensions = true;
  };
}
