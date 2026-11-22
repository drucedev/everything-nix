{
  config,
  lib,
  ...
}:

let
  hosts = config.flake.nixosConfigurations // config.flake.darwinConfigurations;

  osOf = system: lib.last (lib.splitString "-" system);

  unsupportedFor =
    hostOs:
    builtins.filter (
      p: (p.meta.platforms or null) != null && !(builtins.elem hostOs (map osOf p.meta.platforms))
    );
in
{
  perSystem =
    { pkgs, system, ... }:
    {
      checks = lib.concatMapAttrs (
        name: host:
        let
          hostSystem = host.pkgs.stdenv.hostPlatform.system;
          hostPackages =
            host.config.environment.systemPackages
            ++ lib.concatMap (user: user.packages) (builtins.attrValues host.config.users.users);
          bad = unsupportedFor (osOf hostSystem) hostPackages;
        in
        lib.optionalAttrs (system == hostSystem) {
          "${lib.toLower name}-supported-packages" =
            if bad == [ ] then
              pkgs.runCommand "${lib.toLower name}-supported-packages" { } "touch $out"
            else
              throw ''
                ${name}: system and user packages do not support ${hostSystem}:
                  ${builtins.concatStringsSep ", " (map (p: p.pname or p.name) bad)}
              '';
        }
      ) hosts;
    };
}
