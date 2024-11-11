{ config, sops, primaryDomain, ... }:

{
	sops.secrets = {
    "Passwords/ldapUsers" = { owner = "nscd"; key = "Passwords/ldap"; };
  };
	
	users.ldap = {
    enable = true;
    base = "DC=ldap,DC=datumine,DC=co.uk";
    server = "ldaps://ldaps.${primaryDomain}:636";
		bind = {
			distinguishedName = "cn=ldapservice,ou=users,DC=ldap,DC=datumine,DC=co.uk";
			passwordFile = config.sops.secrets."Passwords/ldapUsers".path;
		};
  };
}