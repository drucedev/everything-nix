# Declarative disk layout for Thor (disko); replaces fileSystems/swapDevices.
#
# Thor's whole-disk by-id path; NEVER point it at a partition.
#
# Fresh installs only — this destroys, formats, and mounts the disk:
#   sudo nix run github:nix-community/disko#disko -- \
#     --mode destroy,format,mount --flake .#Thor
{ ... }:

{
  config.nixos.thor = {
    disko.devices = {
      disk.main = {
        device = "/dev/disk/by-id/nvme-KINGSTON_SKC3000D2048G_50026B768629E5B7";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "2G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "fmask=0077"
                  "dmask=0077"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
