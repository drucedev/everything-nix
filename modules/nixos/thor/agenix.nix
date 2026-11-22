{ ... }:

{
  config.nixos.thor = {
    age.identityPaths = [ "/var/lib/agenix/age-key" ];
  };
}
