# agenix rules file — read by the `agenix` CLI, NOT imported by the flake.
# Lives at the repo root (outside modules/, which import-tree scans).
#
# Setup:
#   1. Generate a key per host:
#        Thor (NixOS):  sudo age-keygen -o /var/lib/agenix/age-key
#        Odin (darwin): sudo age-keygen -o /etc/age/age-key
#   2. Paste each host's PUBLIC key below.
#   3. Add a secret from the repo root:
#        agenix -e mysecret.age
#      then reference it in a module:
#        age.secrets.mysecret.file = ../../mysecret.age;   # path relative to the module
let
  thor = "age1TODO-replace-with-thor-public-key";
  odin = "age1TODO-replace-with-odin-public-key";
  all = [
    thor
    odin
  ];
in
{
  # No secrets yet. Example:
  # "mysecret.age".publicKeys = all;
}
