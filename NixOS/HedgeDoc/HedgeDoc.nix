{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "HedgeDoc/env" = {};
  };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.sops.secrets."HedgeDoc/env".path;
    settings = {
      host = "0.0.0.0";
      domain = "docs.${primaryDomain}";
      protocolUseSSL = true;
      port = 80;
      db = {
        host = "10.0.20.50:5432";
        dialect = "postgresql";
        username = "hedgedoc";
        database = "hedgedoc";
      };
    };
  };
}