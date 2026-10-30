# Shared Nix defaults use only options available on both NixOS and nix-darwin.
# Binary-cache trust is NixOS-only.
{ ... }:

let
  common =
    { ... }:
    {
      # Newer nixpkgs types experimental-features strictly as a list of strings.
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      nix.optimise.automatic = true;
    };
in
{
  config.nixos.base = {
    imports = [ common ];

    # Numtide's cache provides llm-agents packages for the Linux hosts.
    nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
    nix.settings.extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  config.darwin.base = common;
}
