{ lib, ... }:

{
  options.nixos.base = lib.mkOption {
    type = lib.types.deferredModule;
    default = { };
  };

  config.nixos.base = {
    programs.zsh.enable = true;
  };
}
