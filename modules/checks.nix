# Fail evaluation if a host's environment.systemPackages contains a package
# that doesn't support the host's OS. CI is eval-only (--no-build), so wrong-OS
# packages (ghostty-bin on Thor) would otherwise only fail at install time.
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
          bad = unsupportedFor (osOf hostSystem) host.config.environment.systemPackages;
        in
        lib.optionalAttrs (system == hostSystem) {
          "${lib.toLower name}-supported-packages" =
            if bad == [ ] then
              pkgs.runCommand "${lib.toLower name}-supported-packages" { } "touch $out"
            else
              throw ''
                ${name}: environment.systemPackages do not support ${hostSystem}:
                  ${builtins.concatStringsSep ", " (map (p: p.pname or p.name) bad)}
              '';
        }
      ) hosts;
    };
}
