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
      boot.kernelPackages = pkgs.linuxPackages_latest;

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

      programs.niri.enable = true;
      programs.waybar.enable = true;
      programs.xwayland.enable = true;
      # Niri enables gnome-keyring's SSH agent; do not enable programs.ssh.startAgent too.
      programs.gamescope.enable = true;
      programs.steam.enable = true;

      services.displayManager.defaultSession = "niri";
      services.displayManager.regreet.enable = true;

      services.greetd = {
        enable = true;
        settings.default_session = {
          user = "greeter";
          command = "${pkgs.dbus}/bin/dbus-run-session ${lib.getExe pkgs.gamescope} --backend drm --prefer-output DP-5 --force-windows-fullscreen -- ${lib.getExe pkgs.regreet}";
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
