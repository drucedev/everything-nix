{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    proton-vpn
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.defaults = {
    dock.show-recents = false;

    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain."com.apple.keyboard.fnState" = true;

    loginwindow.GuestEnabled = false;

    finder.FXPreferredViewStyle = "clmv";
    finder.AppleShowAllExtensions = true;
  };
}
