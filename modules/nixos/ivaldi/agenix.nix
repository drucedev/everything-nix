{ ... }:

{
  config.nixos.ivaldi = {
    age.identityPaths = [ "/var/lib/agenix/age-key" ];
  };
}
