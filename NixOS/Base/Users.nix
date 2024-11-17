{ config, lib, sops, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/root".neededForUsers = true;
    "Passwords/ldapUsers" = { owner = "nslcd"; key = "Passwords/ldap"; };
  };
  
  users = {
    # Set root user password to value assigned in Sops secret file and disable mutability
    # Unless generating a system image using Nix-Generator, in which case set password to "temp" and allow mutabilily.
    mutableUsers = config.modGenerator.enable;
    users.root = {
      password = if config.modGenerator.enable then "temp" else null;
      hashedPasswordFile =  if config.modGenerator.enable then null else config.sops.secrets."Passwords/root".path;
    };
    ldap = {
      enable = true;
      base = "DC=ldap,DC=datumine,DC=co.uk";
      server = "ldaps://ldaps.${primaryDomain}";
      daemon = {
        enable = true;
        extraConfig = ''
          map passwd loginShell "/run/current-system/sw/bin/zsh"
        '';
      };
      bind = {
        policy = "hard_init";
		  	distinguishedName = "cn=ldapservice,ou=users,DC=ldap,DC=datumine,DC=co.uk";
		  	passwordFile = config.sops.secrets."Passwords/ldapUsers".path;
		  };
    };
  };

  security.pam.services= {
    login.makeHomeDir = true;
    sshd = {
      makeHomeDir = true;
      # text = lib.mkDefault (
      #   lib.mkBefore ''
      #     auth required pam_listfile.so \
      #       item=group sense=allow onerr=fail file=/etc/allowed_groups
      #   ''
      # );
    };
  };

  # environment.etc.allowed_groups = {
  #   text = "admins";
  #   mode = "0444";
  # };
}