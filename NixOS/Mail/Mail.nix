{ sops, config, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/ldap" = {
      owner = "virtualMail";
    };
  };

  mailserver = {
    enable = true;
    enableImap = false;
    enableManageSieve = true;
    enableSubmissionSsl = false;

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
      uris = [ "ldaps.${primaryDomain}" ];
      searchBase = "DC=ldap,DC=datumine,DC=co.uk";
      
      bind = {
        dn = "cn=ldapservice,ou=users,DC=ldap,DC=datumine,DC=co.uk";
        passwordFile = config.sops.secrets."Passwords/ldap".path;
      };
      
      postfix = {
        filter = "(&(objectClass=user)(memberOf=cn=mail,ou=groups,dc=ldap,dc=datumine,dc=co.uk))";
        mailAttribute = "mail";
        uidAttribute = "uid";
      };
      
      dovecot = {
        userFilter = "(&(objectClass=user)(memberOf=cn=mail,ou=groups,dc=ldap,dc=datumine,dc=co.uk))";
      };
    };
  };
}