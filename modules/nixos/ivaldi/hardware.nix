# Non-disk hardware for Ivaldi (disko owns the mounts). Generic module set —
# TODO at install: merge the real `nixos-generate-config` output (initrd
# modules, CPU microcode, kvm module).
{ ... }:

{
  config.nixos.ivaldi =
    { lib, ... }:
    {
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
