# agenix rules file — read by the `agenix` CLI, NOT imported by the flake.
# Generate each host's key (see README), paste the PUBLIC keys below, then:
#   nix run github:ryantm/agenix -- -e mysecret.age
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
