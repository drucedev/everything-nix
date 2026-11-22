# 13. Thor desktop session services

Date: 2026-11-22

Status: Accepted

## Decision

- niri enables gnome-keyring's SSH agent, so `programs.ssh.startAgent` stays
  off.
- GVfs is enabled because Nautilus needs it to list and mount removable drives.
- T3 Code is pinned to TCP 3773 through `T3CODE_PORT`, so the firewall
  exception on the Wi-Fi interface `wlo1` stays valid.
