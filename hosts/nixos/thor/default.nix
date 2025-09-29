# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  nix.settings.experimental-features = "nix-command flakes";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Thor"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.druce = {
    isNormalUser = true;
    description = "Andrei Kukharau";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
  };

  home-manager.users."druce" = ./home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    fastfetch
    wezterm
    wofi
    git
    brave
    discord
    waybar
    tuigreet
  ];

  #  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  #  environment.sessionVariables = {
  #    "__GL_GSYNC_ALLOWED" = "1";
  #    "__GL_MaxFramesAllowed" = "1";
  #    "__GL_YIELD" = "usleep";
  #  };

  powerManagement.cpuFreqGovernor = "performance";

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [ nerd-fonts.jetbrains-mono ];

  programs.hyprland.enable = true;
  #  programs.hyprland.xwayland.enable = true;
  programs.ssh.startAgent = true;

  programs.gamescope.enable = true;
  programs.steam = {
    enable = true;
    #    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "druce";
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      };
    };
  };

  services.pipewire = {
    enable = true;
    #    alsa.enable = true;
    #    pulse.enable = true;
    #    jack.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
  };
  #  hardware.nvidia.forceFullCompositionPipeline = false;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
