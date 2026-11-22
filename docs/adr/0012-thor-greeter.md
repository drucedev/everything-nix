# 12. Run regreet in a minimal niri session on Thor

Date: 2026-11-22

Status: Accepted

## Context

Thor has several monitors. regreet fullscreens on the first monitor it sees,
and the greeter user cannot read Druce's 700-mode home directory.

## Decision

- greetd starts a minimal niri session from `/etc/greetd/niri-greeter.kdl`,
  following regreet's documented niri recipe: spawn regreet, then quit niri
  without confirmation when regreet exits after login. Nothing from the desktop
  autostarts.
- Every program is spawned by absolute store path, including the shell,
  because niri's `spawn-sh-at-startup` would resolve `sh` through the greeter
  user's PATH.
- A window rule is the only thing pinning the login box to DP-5. The `DP-5`
  output block sets only `focus-at-startup`, because niri 25.05 and later
  centres the startup pointer on the focused output (otherwise the first
  name-sorted output, HDMI-A-5). It sets no position, mode, or scale, so niri's
  automatic placement and scaling stay in effect.
- regreet matches the desktop: Catppuccin Mocha with a mauve accent,
  JetBrainsMono Nerd Font, dark mode, and the vendored wallpaper from a store
  path. regreet reads these settings whichever compositor hosts it.
- `greeter.css` follows regreet 0.5.0's widget tree: the login and clock
  frames carry `.background`; entries, buttons, and labels are styled by node
  type because regreet sets no CSS IDs.
- awww paints the same wallpaper, shipped world-readable as
  `/etc/greetd/awww-greeter.png`, on every output, covering the monitors
  regreet's window does not. Its daemon starts inside the greeter session and
  dies with it; its socket name derives from that session's `WAYLAND_DISPLAY`,
  so it never touches Druce's awww daemon.
