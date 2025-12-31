{
  pkgs,
  hm,
  ...
}:

{

  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
    experimental-features = "nix-command flakes";
    fallback = true;
    max-jobs = "auto";
  };

  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 7d";
  };

  environment.systemPackages = with pkgs; [
    btop
  ];

  imports = [
    (if pkgs.stdenv.isDarwin then hm.darwinModules.home-manager else hm.nixosModules.home-manager)
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
}
