{ ... }:

{
  config.users.druce =
    { pkgs, lib, ... }:
    {
      config = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
          users.users.druce = {
            name = "druce";
            home = "/Users/druce";
            shell = "/bin/zsh";
          };
        })
        (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
          users.users.druce = {
            isNormalUser = true;
            description = "Andrei Kukharau";
            extraGroups = [
              "networkmanager"
              "wheel"
              "kvm"
            ];
            shell = pkgs.zsh;
          };
        })
      ];
    };
}
