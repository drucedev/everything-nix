{ ... }:

{
  config.nixos.ivaldi =
    { lib, ... }:
    {
      hardware.enableRedistributableFirmware = true;
      hardware.cpu.intel.updateMicrocode = true;
      hardware.cpu.amd.updateMicrocode = true;

      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];

      networking.useDHCP = lib.mkDefault true;
    };
}
