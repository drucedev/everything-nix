{
  description = "Durce's everything nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Nix darwin
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, ... } @ inputs:
  let
    system = "x86_64-darwin";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."Odin" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [ 
        ./configuration.nix
        home-manager.darwinModule.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.druce = ./druce.nix;
        }
      ];
    };

    darwinPackages = self.darwinConfigurations."Odin".pkgs;
  };
}
