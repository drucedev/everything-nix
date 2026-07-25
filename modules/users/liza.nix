# Liza — login user on Odin only (imported solely into the darwin eval).
{ ... }:

{
  config.users.liza =
    { ... }:
    {
      users.users.liza = {
        name = "liza";
        home = "/Users/liza";
        shell = "/bin/zsh";
      };
    };
}
