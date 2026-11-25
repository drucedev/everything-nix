{
  lib,
  ...
}:

{
  options.nixos.thor = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config.nixos.thor =
    { pkgs, ... }:
    {
      networking.hostName = "Thor";
      system.stateVersion = "26.05";

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        maxGenerations = 10;
      };
      boot.kernelPackages = pkgs.linuxPackages_zen;

      networking.networkmanager.enable = true;

      environment.sessionVariables.T3CODE_PORT = "3773";
      networking.firewall.interfaces."wlo1".allowedTCPPorts = [ 3773 ];

      time.timeZone = "Europe/Berlin";

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      powerManagement.cpuFreqGovernor = "performance";

      programs.niri.enable = true;
      programs.nix-ld.enable = true;
      programs.xwayland.enable = true;
      programs.steam.enable = true;

      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      services.displayManager.defaultSession = "niri";
      services.displayManager.regreet = {
        enable = true;
        font = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        settings = {
          background = {
            path = ./thor/catpuccin-stars.png;
            fit = "Cover";
          };
          GTK.application_prefer_dark_theme = true;
        };
        extraCss = ./thor/greeter.css;
      };

      environment.etc."greetd/awww-greeter.png".source = ./thor/catpuccin-stars.png;

      environment.etc."greetd/niri-greeter.kdl".text = ''
        spawn-at-startup "${lib.getExe pkgs.awww}" "img" "/etc/greetd/awww-greeter.png"
        spawn-at-startup "${lib.getExe pkgs.bash}" "-c" "${lib.getExe pkgs.regreet}; ${lib.getExe pkgs.niri} msg action quit --skip-confirmation"

        hotkey-overlay {
            skip-at-startup
        }

        window-rule {
            match app-id=r#"^apps\.regreet$"#
            open-on-output "DP-5"
        }

        output "DP-5" {
            focus-at-startup
        }
      '';

      services.greetd = {
        enable = true;
        settings.default_session = {
          user = "greeter";
          command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.niri} --config /etc/greetd/niri-greeter.kdl";
        };
      };

      services.udisks2.enable = true;
      services.gvfs.enable = true;

      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };
      security.rtkit.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
      };
    };
}
