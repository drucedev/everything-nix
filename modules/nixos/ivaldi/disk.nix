# Declarative disk layout for Ivaldi (disko); replaces fileSystems/swapDevices.
#
# TODO before first install: set `device` to the actual whole-disk by-id path
# (find it: lsblk -o NAME,LINKS). NEVER point it at a partition.
#
# Fresh installs only — this reformats the disk:
#   sudo nix run github:nix-community/disko#disko-install -- --flake .#Ivaldi --disk main /dev/sda
{ ... }:

{
  config.nixos.ivaldi = {
    disko.devices = {
      disk.main = {
        # TODO: replace with the real disk by-id path.
        device = "/dev/disk/by-id/TODO-REPLACE-WITH-ACTUAL-DISK-ID";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              name = "ESP";
              size = "512M";
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
            swap = {
              size = "4G";
              content = {
                type = "swap";
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
