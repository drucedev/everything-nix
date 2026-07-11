# Shared CLI tools installed on both hosts. `stow` is included so dotfiles
# (managed in a separate GNU stow repo) can be deployed on any host.
{ ... }:

let
  cliPackages =
    pkgs: with pkgs; [
      lsd
      fd
      ripgrep
      git
      fastfetch
      proton-pass-cli
      stow
      starship
    ];
in
{
  config.nixos.base =
    { pkgs, ... }:
    {
      environment.systemPackages = cliPackages pkgs;
    };

  config.darwin.base =
    { pkgs, ... }:
    {
      environment.systemPackages = cliPackages pkgs;
    };
}
