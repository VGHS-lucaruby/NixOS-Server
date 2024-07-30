{ config, ... }:

{
  sops.secrets."Passwords/root".neededForUsers = true;
  # todo LDAP
  users = {
    # mutableUsers = true;
    # users.root.password = "temp";
    mutableUsers = false;
    users.root.hashedPasswordFile = config.sops.secrets."Passwords/root".path;
  };
}