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
    { pkgs, ... }:
    {
      networking.hostName = "Ivaldi";
      system.stateVersion = "26.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      nix.gc = {
        automatic = true;
        options = "--delete-older-than 7d";
      };

      networking.networkmanager.enable = true;

      nix.settings.extra-trusted-public-keys = [
        "thor-1:Q18iQ9fEziCrIyCqjYrl9Am+PMj1zq96txG8OY4r+ak="
      ];

      time.timeZone = "Europe/Berlin";
      i18n.defaultLocale = "en_US.UTF-8";

      users.users.druce = {
        linger = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPH75Me4yVpJkd6cB1LLGibTID5yHMLtPvCM9qgGtpM7 druce@thor"
        ];
      };

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
          AllowUsers = [ "druce" ];
          MaxAuthTries = 3;
          LoginGraceTime = 30;
        };
        openFirewall = false;
      };

      security.sudo.execWheelOnly = true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        nss
        nspr
        glib
        atk
        at-spi2-atk
        at-spi2-core
        dbus
        libx11
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxrandr
        libxcb
        libxkbcommon
        mesa
        alsa-lib
        expat
        fontconfig
      ];
      fonts.packages = [ pkgs.dejavu_fonts ];

      networking.firewall.interfaces.enp1s0.allowedTCPPorts = [
        22
        3773
      ];

      systemd.user.extraConfig = ''
        DefaultEnvironment=PATH=/run/wrappers/bin:/run/current-system/sw/bin:/usr/bin:/bin NIX_LD=/run/current-system/sw/share/nix-ld/lib/ld.so NIX_LD_LIBRARY_PATH=/run/current-system/sw/share/nix-ld/lib
      '';

      systemd.user.services.t3code = {
        overrideStrategy = "asDropin";
        serviceConfig.Environment = [ "T3CODE_PORT=3773" ];
      };
    };
}
