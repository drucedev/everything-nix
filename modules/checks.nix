# Fail evaluation if a host's environment.systemPackages or any user's
# packages contain a package that doesn't support the host's OS. CI is
# eval-only (--no-build), so wrong-OS packages (ghostty-bin on Thor) would
# otherwise only fail at install time.
#
# Compared by OS family, not full system triple: nixpkgs arch annotations are
# often stricter than reality (ghostty-bin declares aarch64-darwin only, yet
# ships a universal binary that runs on Odin's x86_64-darwin).
{
  config,
  lib,
  ...
}:

let
  # All declared hosts; new ones are picked up automatically.
  hosts = config.flake.nixosConfigurations // config.flake.darwinConfigurations;

  osOf = system: lib.last (lib.splitString "-" system);

  # Packages that declare meta.platforms with no entry for the host's OS.
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
          # Per-user delivery (users.users.<name>.packages) must obey the same
          # OS guard as system packages.
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
