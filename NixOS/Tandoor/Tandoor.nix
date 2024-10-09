{ config, sops, primaryDomain, ... }:

{
  sops.secrets = {
    "Tandoor/env" = { owner = "tandoor_recipes"; };
  };

  users = {
    users.tandoor_recipes = {
      isSystemUser = true;
      homeMode = "750";
      group = "tandoor_recipes";
    };
    groups.tandoor_recipes = {};
  };

  systemd.services.tandoor-recipes ={
    serviceConfig = {
      EnvironmentFile = config.sops.secrets."Tandoor/env".path;
    };
  };

  services.tandoor-recipes = {
    enable = true;
    address = "0.0.0.0";
    extraConfig = {
      ALLOWED_HOSTS="recipes.${primaryDomain}";
      GUNICORN_MEDIA=1;
      DB_ENGINE="django.db.backends.postgresql";
      POSTGRES_HOST="10.0.20.50";
      POSTGRES_DB="tandoor";
      POSTGRES_PORT=5432;
      LDAP_AUTH=1;
      AUTH_LDAP_ALWAYS_UPDATE_USER=1;
      AUTH_LDAP_CACHE_TIMEOUT=300;
      AUTH_LDAP_SERVER_URI="ldaps://ldaps.${primaryDomain}:636";
      AUTH_LDAP_BIND_DN="cn=ldapservice,ou=users,DC=ldap,DC=datumine,DC=co.uk";
      AUTH_LDAP_USER_SEARCH_BASE_DN="ou=users,DC=ldap,DC=datumine,DC=co.uk";
      AUTH_LDAP_USER_SEARCH_FILTER_STR="(cn=%(user)s)";
      AUTH_LDAP_USER_ATTR_MAP="{'username': 'cn', 'email': 'mail'}";
    };
  };
}