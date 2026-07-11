# Zig devshell: `nix develop .#zig`
{ ... }:

{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.zig = pkgs.mkShell {
        packages = with pkgs; [ zig ];
      };
    };
}
