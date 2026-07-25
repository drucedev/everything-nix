# Allow unfree packages on both classes.
{ ... }:

{
  config.nixos.base = {
    nixpkgs.config.allowUnfree = true;
  };

  config.darwin.base = {
    nixpkgs.config.allowUnfree = true;
  };
}
