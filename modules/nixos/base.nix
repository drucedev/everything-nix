# The reusable NixOS base; cross-class files (nix.nix, packages/*, ...) merge into it.
{ lib, ... }:

{
  options.nixos.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  # Needed so users.users.druce.shell = pkgs.zsh resolves.
  config.nixos.base = {
    programs.zsh.enable = true;
  };
}
