{
  description = "Durce's everything nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable?shallow=true";
    #nixos-stable.url = "github:NixOS/nixpkgs/nixos-25.05?shallow=true";

    # Nix darwin
    darwin.url = "github:nix-darwin/nix-darwin/master?shallow=true";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    hm.url = "github:nix-community/home-manager?shallow=true";
    hm.inputs.nixpkgs.follows = "nixpkgs";
    #hm-stable.url = "github:nix-community/home-manager?shallow=true";
    #hm-stable.inputs.nixpkgs.follows = "nixos-stable";
  };

  outputs =
    inputs@{
      nixpkgs,
      darwin,
      hm,
      ...
    }:

    {
      darwinConfigurations = (
        import ./hosts/darwin {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            darwin
            hm
            ;
        }
      );

      nixosConfigurations = (
        import ./hosts/nixos {
          inherit (nixpkgs) lib;
          inherit
            inputs
            nixpkgs
            hm
            ;
        }
      );
    };
}
