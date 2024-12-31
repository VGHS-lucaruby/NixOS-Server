{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "FireFly/appKey" = { owner = "firefly-iii"; };
    "FireFly/postgresPassword" = { owner = "firefly-iii"; };
  };

  services = {  
    firefly-iii = {
      enable = true;
      enableNginx = true;
      settings = {
        APP_ENV = "production";
        APP_URL = "FireFly.${primaryDomain}";
        APP_KEY_FILE = config.sops.secrets."FireFly/appKey".path;
        DB_CONNECTION = "pgsql";
        DB_HOST = "10.0.20.50";
        DB_PORT = 5432;
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD_FILE = config.sops.secrets."FireFly/postgresPassword".path;
        DEFAULT_LANGUAGE = "en_GB";
        TZ = "Europe/London";
        TRUSTED_PROXIES = "*";
      };
    };
  };
}