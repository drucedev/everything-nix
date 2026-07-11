# Declares the `nixos.base` deferredModule option. Its content is contributed by
# the cross-class files (nix.nix, nixpkgs.nix, fonts.nix, packages/*) and by the
# nixos-base defaults below; every NixOS host composes `nixos.base` into itself.
{ lib, ... }:

{
  options.nixos.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  # nixos-base defaults: zsh is enabled on every NixOS host so that
  # `users.users.druce.shell = pkgs.zsh` (set in modules/users/druce.nix) resolves.
  config.nixos.base = {
    programs.zsh.enable = true;
  };
}
