{ ... }:

{
  config.nixos.thor =
    { config, lib, ... }:
    {
      hardware.enableRedistributableFirmware = true;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [
        "kvm-intel"
        "nvidia"
        "nvidia_modeset"
        "nvidia_drm"
      ];
      boot.extraModulePackages = [ ];

      networking.useDHCP = lib.mkDefault true;

      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
}
