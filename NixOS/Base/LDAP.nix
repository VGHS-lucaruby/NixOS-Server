{ config, lib, sops, primaryDomain, ... }:

{
  sops.secrets = {
    "LDAP/sssdEnv" = {};
  };

  services.sssd = {
    enable = true;
    sshAuthorizedKeysIntegration = true;

    environmentFile = config.sops.secrets."LDAP/sssdEnv".path;

    config = ''
      [nss]
      filter_groups = root
      filter_users = root
      reconnection_retries = 3
      
      [sssd]
      config_file_version = 2
      reconnection_retries = 3
      domains = ${primaryDomain}
      services = nss, pam, ssh
      
      [pam]
      reconnection_retries = 3
      
      [domain/${primaryDomain}]
      cache_credentials = True
      default_shell = /run/current-system/sw/bin/zsh
      id_provider = ldap
      chpass_provider = ldap
      auth_provider = ldap
      access_provider = ldap
      ldap_uri = ldaps://ldaps.${primaryDomain}:636
      
      ldap_schema = rfc2307bis
      ldap_search_base = DC=ldap,DC=datumine,DC=co.uk
      ldap_user_search_base = ou=users,DC=ldap,DC=datumine,DC=co.uk
      ldap_group_search_base = DC=ldap,DC=datumine,DC=co.uk
      
      ldap_user_object_class = user
      ldap_user_name = cn
      ldap_group_object_class = group
      ldap_group_name = cn

      ldap_default_bind_dn = cn=srv-LDAP-Server,ou=services,DC=ldap,DC=datumine,DC=co.uk
      ldap_default_authtok = $SSSD_LDAP_DEFAULT_AUTHTOK
    '';
  };

  security.pam.services= {
    login.makeHomeDir = true;
    sshd.makeHomeDir = true;
    systemd-user.makeHomeDir = true;
  };

  security.sudo = {
    extraRules = [
      { groups = [ "server-admin-sudo" ]; commands = [ "ALL" ]; }
    ];
  };
}