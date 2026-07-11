{
  description = "Druce's everything nix flake";

  inputs = {
    # Stable nixpkgs — used for nix-darwin (Odin) and perSystem dev tools.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin?shallow=true";

    # Unstable nixpkgs — used for the NixOS host (Thor).
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable?shallow=true";

    # nix-darwin
    darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05?shallow=true";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # flake-parts is the top-level configuration; import-tree auto-imports ./modules.
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:denful/import-tree";

    # Disko — declarative disk layout for Thor.
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # agenix — age-encrypted secrets.
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "darwin";

    # NOTE: home-manager was removed. Dotfiles are managed with GNU stow in a
    # separate repo; this flake only installs `stow` as a system package.
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);
}
