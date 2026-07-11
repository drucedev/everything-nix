# agenix identity for Odin (darwin). The age secret key must exist at this path;
# generate it with `sudo age-keygen -o /etc/age/age-key` and record the matching
# public key in ./secrets.nix (see README). nix-darwin activation runs as root,
# so the key path must be root-readable.
{ ... }:

{
  config.darwin.odin = {
    age.identityPaths = [ "/etc/age/age-key" ];
  };
}
