{ sops, config, primaryDomain, ... }:

{
  sops.secrets = {
    "LDAP/mail" = { owner = "virtualMail"; };
  };

  mailserver = {
    enable = true;
    enableImap = false;
    enableManageSieve = true;
    enableSubmission = false;

    fqdn = "mail.${primaryDomain}";
    domains = [ "${primaryDomain}" ];
    
    rebootAfterKernelUpgrade.enable = true;
    useUTF8FolderNames = true;
    useFsLayout = true;
    virusScanning = true;
    localDnsResolver = false;
    dkimKeyBits = 2048;
    hierarchySeparator = "/";
    
    dmarcReporting = {
      enable = true;
      domain = "${primaryDomain}";
      localpart = "dmarc-reports";
      fromName = "${primaryDomain}";
      organizationName = "Datumine";
    };

    ldap = {
      enable = true;
      uris = [ "ldaps://ldaps.${primaryDomain}" ];
      searchBase = "DC=ldap,DC=datumine,DC=co.uk";
      
      bind = {
        dn = "cn=srv-LDAP-Mailserver,ou=services,DC=ldap,DC=datumine,DC=co.uk";
        passwordFile = config.sops.secrets."LDAP/mail".path;
      };
      
      postfix = {
        filter = "(&(objectClass=user)(memberOf=cn=mail,ou=groups,dc=ldap,dc=datumine,dc=co.uk)(|(mail=%s)(mail-alias=%s)))"; # Will require MR!351 for aliases to work properly
        mailAttribute = "mail";
      };
      
      dovecot = {
        userFilter = "(&(objectClass=user)(memberOf=cn=mail,ou=groups,dc=ldap,dc=datumine,dc=co.uk)(mail=%u))";
        passFilter = "(&(objectClass=user)(memberOf=cn=mail,ou=groups,dc=ldap,dc=datumine,dc=co.uk)(mail=%u))";
      };
    };
  };
}