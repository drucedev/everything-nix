# Allow unfree packages on both classes. Previously this came in through the
# `specialArgs`-injected `pkgs = import nixpkgs { config.allowUnfree = true; }`
# pass-thru; now it is a plain module option on each host's eval.
{ ... }:

{
  config.nixos.base = {
    nixpkgs.config.allowUnfree = true;
  };

  config.darwin.base = {
    nixpkgs.config.allowUnfree = true;
  };
}
