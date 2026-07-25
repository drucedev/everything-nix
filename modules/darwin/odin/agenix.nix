# Odin's age key; generate: sudo age-keygen -o /etc/age/age-key (pubkey -> secrets.nix).
# Must be root-readable (darwin activation runs as root).
{ ... }:

{
  config.darwin.odin = {
    age.identityPaths = [ "/etc/age/age-key" ];
  };
}
