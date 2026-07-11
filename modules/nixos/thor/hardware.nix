# Non-disk hardware for Thor — the bits of the old generated
# `hardware-configuration.nix` that disko does NOT own (disko owns the mounts).
# `nixpkgs.hostPlatform` is set in modules/hosts.nix, not here.
{ ... }:

{
  config.nixos.thor =
    { config, lib, ... }:
    {
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      networking.useDHCP = lib.mkDefault true;

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
