{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "FireFly/appKey" = { owner = "firefly-iii"; };
    "FireFly/postgresPassword" = { owner = "firefly-iii"; };
    "FireFly/accessToken" = { owner = "firefly-iii"; };
    "FireFly/nordigenID" = { owner = "firefly-iii"; };
    "FireFly/nordigenKey" = { owner = "firefly-iii"; };
  };

  services = {  
    firefly-iii = {
      enable = true;
      enableNginx = true;
      virtualHost = "firefly.${primaryDomain}";
      settings = {
        APP_ENV = "production";
        APP_URL = "firefly.${primaryDomain}";
        APP_KEY_FILE = config.sops.secrets."FireFly/appKey".path;
        DB_CONNECTION = "pgsql";
        DB_HOST = "10.0.20.50";
        DB_PORT = 5432;
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.sops.secrets."FireFly/postgresPassword".path;
        DEFAULT_LANGUAGE = "en_GB";
        TZ = "Europe/London";
        TRUSTED_PROXIES = "**";
      };
    };
    firefly-iii-data-importer = {
      enable = true;
      enableNginx = true;
      virtualHost = "fireflydi.${primaryDomain}";
      settings = {
        APP_ENV = "production";
        APP_URL = "fireflydi.${primaryDomain}";
        FIREFLY_III_URL = "https://firefly.${primaryDomain}";
        VANITY_URL = "https://firefly.${primaryDomain}";
        TRUSTED_PROXIES = "**";
      };
    };
  };
}