# Kotlin devshell: `nix develop .#kotlin`
{ ... }:

{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devShells.kotlin = pkgs.mkShell {
        packages = with pkgs; [
          jdk
          gradle
          kotlin
          kotlin-language-server
        ];
      };
    };
}
