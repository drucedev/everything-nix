{
  description = "Durce's everything nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Nix darwin
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      darwin,
      home-manager,
      ...
    }:
    let
      vars = {
        user = "druce";
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
            home-manager
            vars
            ;
        }
      );
    };
}
