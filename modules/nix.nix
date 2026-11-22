{ ... }:

let
  common =
    { ... }:
    {
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

    nix.settings.extra-substituters = [ "https://cache.numtide.com" ];
    nix.settings.extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };
  config.darwin.base = common;
}
