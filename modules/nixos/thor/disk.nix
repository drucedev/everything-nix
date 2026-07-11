# Declarative disk layout for Thor (disko). This REPLACES the `fileSystems` /
# `swapDevices` that used to live in hosts/nixos/thor/hardware-configuration.nix.
#
# TODO before first install:
#   1. Set `device` to this machine's actual whole-disk path, e.g.
#        /dev/disk/by-id/nvme-eui.0000000000000000...
#      Find it with `lsblk -o NAME,LINKS`. NEVER point this at a partition.
#   2. Adjust partition sizes to taste.
#
# Applied on a FRESH install with (see README for the full flow):
#   sudo nix run github:nix-community/disko#disko-install -- --flake .#Thor --disk main /dev/nvme0n1
# (replace the disk; it must match `device` below). This is the flake-based form —
# disk.nix is a module setting `config.nixos.thor`, NOT a standalone disko config, so
# the `disko <file>` standalone form does not apply. Do NOT run disko's format step
# against a disk you want to keep.
{ ... }:

{
  config.nixos.thor = {
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
              size = "8G";
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
