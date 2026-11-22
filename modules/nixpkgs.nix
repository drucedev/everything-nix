{ ... }:

{
  config.nixos.base = {
    nixpkgs.config.allowUnfree = true;
  };

  config.darwin.base = {
    nixpkgs.config.allowUnfree = true;
  };
}
