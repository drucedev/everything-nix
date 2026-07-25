# Thor's age key; generate: sudo age-keygen -o /var/lib/agenix/age-key (pubkey -> secrets.nix).
{ ... }:

{
  config.nixos.thor = {
    age.identityPaths = [ "/var/lib/agenix/age-key" ];
  };
}
