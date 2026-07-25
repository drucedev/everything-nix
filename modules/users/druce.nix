# Druce's user, imported by both hosts; branches by platform (NixOS-only flags
# like isNormalUser don't exist on nix-darwin). Packages live in packages/*.
{ ... }:

{
  config.users.druce =
    { pkgs, lib, ... }:
    {
      # Two mkIf-guarded platform branches (a module can't assign config twice).
      config = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          # nix-darwin: system zsh at /bin/zsh (already in /etc/shells).
          users.users.druce = {
            name = "druce";
            home = "/Users/druce";
            shell = "/bin/zsh";
          };
        })
        (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
          # NixOS: the nix zsh (programs.zsh.enable is set in nixos/base.nix).
          users.users.druce = {
            isNormalUser = true;
            description = "Andrei Kukharau";
            extraGroups = [
              "networkmanager"
              "wheel"
            ];
            shell = pkgs.zsh;
          };
        })
      ];
    };
}
