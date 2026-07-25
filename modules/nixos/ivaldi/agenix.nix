# Ivaldi's age key; generate: sudo age-keygen -o /var/lib/agenix/age-key (pubkey -> secrets.nix).
{ ... }:

{
  config.nixos.ivaldi = {
    age.identityPaths = [ "/var/lib/agenix/age-key" ];
  };
}
