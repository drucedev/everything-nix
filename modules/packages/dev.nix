# Shared development tools installed on both hosts.
{ ... }:

let
  devPackages =
    pkgs: with pkgs; [
      nixd
      nixfmt
      pnpm
    ];
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = devPackages pkgs;
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = devPackages pkgs;
    };
}
