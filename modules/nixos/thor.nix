# Thor — NixOS host (x86_64-linux, nixpkgs-unstable): identity + unique desktop
# stack. Hardware/disk/agenix live in thor/*.nix; hosts.nix composes nixos.base
# alongside. The config is a function so nixosSystem injects `pkgs`.
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
      # Do NOT change after install — pins migration behavior.
      system.stateVersion = "26.05";

      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.limine = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        maxGenerations = 10;
      };
      # Zen is tuned for desktop responsiveness and is available in nixpkgs.
      boot.kernelPackages = pkgs.linuxPackages_zen;

      networking.networkmanager.enable = true;

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

      # Niri enables gnome-keyring's SSH agent; do not enable programs.ssh.startAgent too.
      programs.niri.enable = true;
      programs.waybar.enable = true;
      programs.xwayland.enable = true;
      programs.steam.enable = true;

      # Per-project devshells enter via `use flake` .envrc files.
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      services.displayManager.defaultSession = "niri";
      services.displayManager.regreet.enable = true;

      # Minimal niri session hosting regreet for greetd, per regreet's
      # documented niri recipe: spawn regreet, then quit niri (skip
      # confirmation) when it exits after the login handoff. regreet
      # fullscreens on the first monitor it sees, so the DP-5 window rule is
      # the only mechanism pinning the login box to that output. Every
      # program is spawned by absolute store path — including the shell,
      # because niri's spawn-sh-at-startup would resolve `sh` through the
      # greeter user's PATH. No desktop autostarts here.
      environment.etc."greetd/niri-greeter.kdl".text = ''
        spawn-at-startup "${lib.getExe pkgs.bash}" "-c" "${lib.getExe pkgs.regreet}; ${lib.getExe pkgs.niri} msg action quit --skip-confirmation"

        hotkey-overlay {
            skip-at-startup
        }

        window-rule {
            match app-id=r#"^apps\.regreet$"#
            open-on-output "DP-5"
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

      # Thor's package set is contributed by packages.nix; desktop programs above
      # add their own runtime packages.
    };
}
