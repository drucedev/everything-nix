# Druce's user definition. Imported by both Thor (NixOS) and Odin (darwin), so
# the user record branches by platform: NixOS user flags (`isNormalUser`,
# `extraGroups`) don't exist on nix-darwin, and the home path / login shell
# differ. Per-user packages are NOT here — they live in `modules/packages/*`
# (system-wide) and dotfiles are managed with GNU stow, outside this flake.
{ ... }:

{
  # `config.users.druce` stores a deferred module (declared by modules/users.nix
  # as `attrsOf deferredModule`); modules/hosts.nix imports it into each host.
  config.users.druce =
    { pkgs, lib, ... }:
    {
      # A single module cannot assign `config` twice, so the two platform
      # branches are merged; each is guarded by mkIf so only one applies.
      config = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          # nix-darwin: system zsh at /bin/zsh (already in /etc/shells).
          users.users.druce = {
            name = "druce";
            home = "/Users/druce";
            shell = "/bin/zsh";
          };
        })
        (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
          # NixOS: the nix zsh (programs.zsh.enable is set in nixos/base.nix).
          users.users.druce = {
            isNormalUser = true;
            description = "Andrei Kukharau";
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
            shell = pkgs.zsh;
          };
        })
      ];
    };
}
