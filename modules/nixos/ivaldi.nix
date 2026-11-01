# Ivaldi — small home server (x86_64-linux, nixpkgs-stable). Hardware, disk,
# and agenix live in ivaldi/*.nix; hosts.nix composes nixos.base alongside.
# Packages live in modules/packages.nix.
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

      # Key-only SSH. Thor's key is enough to reach a headless box; add others
      # before install. The console password from `passwd druce` still works.
      users.users.druce = {
        # `t3 service install` is a user unit. Without linger it dies at logout
        # and does not start at boot.
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
        };
      };

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # T3 downloads a headless Chrome that is not a Nix binary. `t3 browser
      # setup` installs libraries with apt, which this host does not have.
      # nix-ld supplies them. User services do not see sessionVariables, so the
      # linker path is also set on the user manager below.
      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        nss
        nspr
        glib
        atk
        at-spi2-atk
        at-spi2-core
        dbus
        xorg.libX11
        xorg.libXcomposite
        xorg.libXdamage
        xorg.libXext
        xorg.libXfixes
        xorg.libXrandr
        xorg.libxcb
        libxkbcommon
        mesa
        alsa-lib
        expat
        fontconfig
      ];
      fonts.packages = [ pkgs.dejavu_fonts ];

      # LAN pairing only. T3 Connect is outbound and does not need this.
      # Do not forward the port; a pairing code is the only LAN auth, and T3
      # still refuses public addresses when started with `--lan`.
      networking.firewall.allowedTCPPorts = [ 3773 ];

      # Login PATH and nix-ld vars are not exported to lingering user services.
      systemd.user.extraConfig = ''
        DefaultEnvironment=PATH=/run/wrappers/bin:/run/current-system/sw/bin:/usr/bin:/bin NIX_LD=/run/current-system/sw/share/nix-ld/lib/ld.so NIX_LD_LIBRARY_PATH=/run/current-system/sw/share/nix-ld/lib
      '';

      # `t3 service install` owns the unit. This drop-in only pins the port
      # the firewall opens. `~/.t3/service.env` can still override it.
      systemd.user.services.t3code = {
        overrideStrategy = "asDropin";
        serviceConfig.Environment = [ "T3CODE_PORT=3773" ];
      };
    };
}
