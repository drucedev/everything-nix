{ ... }:

{
  config.nixos.ivaldi = {
    hardware.enableRedistributableFirmware = true;
    hardware.cpu.intel.updateMicrocode = true;

    boot.initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "sdhci_pci"
    ];
    boot.kernelModules = [ "kvm-intel" ];
  };
}
