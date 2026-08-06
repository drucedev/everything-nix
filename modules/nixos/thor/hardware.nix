# Non-disk hardware for Thor (disko owns the mounts).
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
      # Load NVIDIA DRM before the direct-DRM Gamescope greeter starts.
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
