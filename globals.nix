{
  pkgs,
  hm-unstable,
  ...
}:

{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  imports = [
    (
      if pkgs.stdenv.isDarwin then
        hm-unstable.darwinModules.home-manager
      else
        hm-unstable.nixosModules.home-manager
    )
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
