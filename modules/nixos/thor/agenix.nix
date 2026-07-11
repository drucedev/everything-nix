# agenix identity for Thor. The age secret key must exist at this path on the
# host; generate it with `age-keygen -o /var/lib/agenix/age-key` and record the
# matching public key in modules/secrets.nix (see README).
{ ... }:

{
  config.nixos.thor = {
    age.identityPaths = [ "/var/lib/agenix/age-key" ];
  };
}
