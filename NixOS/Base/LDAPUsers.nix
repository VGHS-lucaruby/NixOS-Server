{ config, sops, primaryDomain, ... }:

{
	sops.secrets = {
    "Passwords/ldap" = { owner = "nscd"; };
  };
	
	users.ldap = {
    enable = true;
    base = "DC=ldap,DC=datumine,DC=co.uk";
    server = "ldap://ldad.${primaryDomain}";
    useTLS = true;
		bind = {
			distinguishedName = "cn=ldapservice,ou=users,DC=ldap,DC=datumine,DC=co.uk";
			passwordFile = config.sops.secrets."Passwords/ldap".path;
		};
  };
}