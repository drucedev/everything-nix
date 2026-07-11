# Thor — the NixOS host (x86_64-linux, nixpkgs-unstable). Holds Thor's identity +
# hardware + unique desktop stack ONLY; the reusable `nixos.base` is imported
# alongside this by modules/hosts.nix (not composed here), so both apply to the
# system and merge naturally in the NixOS eval. Disk layout is in
# nixos/thor/disk.nix (disko), non-disk hardware in nixos/thor/hardware.nix,
# agenix identity in nixos/thor/agenix.nix; all merge into `nixos.thor` across
# files via deferredModule.
#
# The config block is a FUNCTION `{ pkgs, ... }:` (not a bare attrset) so that
# `pkgs` is injected by nixosSystem at import time — flake-parts does not
# provide `pkgs` at the top-level module scope.
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
      # Do NOT change this after install — it pins NixOS migration behavior.
      system.stateVersion = "25.05";

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
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

      programs.hyprland.enable = true;
      programs.ssh.startAgent = true;
      programs.gamescope.enable = true;
      programs.steam.enable = true;
      programs.gamemode.enable = true;

      services.greetd = {
        enable = true;
        settings.default_session = {
          user = "druce";
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        };
      };

      services.udisks2.enable = true;

      services.pipewire.enable = true;

      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.graphics.enable = true;
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        open = true;
      };

      # Thor-specific desktop/GUI tools not shared with Odin. Shared GUI apps
      # (brave, wezterm, zed-editor) come from modules/packages/gui.nix via base.
      environment.systemPackages = with pkgs; [
        wofi
        waybar
        tuigreet
        kitty
        discord
      ];
    };
}
