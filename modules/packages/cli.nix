# Shared CLI tools; stow deploys dotfiles from the separate stow repo.
{ ... }:

let
  cliPackages =
    pkgs: with pkgs; [
      lsd
      fd
      ripgrep
      fzf
      zoxide
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
