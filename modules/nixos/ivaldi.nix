# Ivaldi — small home server (x86_64-linux, nixpkgs-unstable): minimal identity
# for now; enrich after install. Hardware/disk/agenix live in ivaldi/*.nix;
# hosts.nix composes nixos.base alongside.
{
  lib,
  ...
}:

{
  options.nixos.ivaldi = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config.nixos.ivaldi =
    { ... }:
    {
      networking.hostName = "Ivaldi";
      # Do NOT change after install — pins migration behavior.
      system.stateVersion = "26.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      networking.networkmanager.enable = true;

      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";

      # Headless baseline: SSH in from another machine. TODO: add druce's
      # authorizedKeys, then consider settings.PasswordAuthentication = false.
      services.openssh.enable = true;
    };
}
