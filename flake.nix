{
  description = "Durce's everything nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Nix darwin
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    hm-unstable.url = "github:nix-community/home-manager";
    hm-unstable.inputs.nixpkgs.follows = "nixpkgs";
    hm-stable.url = "github:nix-community/home-manager";
    hm-stable.inputs.nixpkgs.follows = "nixos-stable";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      hm-unstable,
      ...
    }:
    let
      vars = {
        users = [
          "druce"
          "liza"
        ];
      };
    in
    {
      darwinConfigurations = (
        import ./hosts/darwin {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            darwin
            hm-unstable
            vars
            ;
        }
      );
    };
}
