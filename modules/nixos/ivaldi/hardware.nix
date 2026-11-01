# Non-disk hardware for Ivaldi (disko owns the mounts). Generic module set —
# TODO at install: merge the real `nixos-generate-config` output (initrd
# modules, CPU microcode, kvm module).
{ ... }:

{
  config.nixos.ivaldi =
    { lib, ... }:
    {
      # Unknown board until install. The unused microcode image is ignored.
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
