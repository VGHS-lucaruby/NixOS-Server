{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "HedgeDoc/env" = { owner = "hedgedoc"; };
  };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.sops.secrets."HedgeDoc/env".path;
    settings = {
      host = "0.0.0.0";
      domain = "docs.${primaryDomain}";
      protocolUseSSL = true;
      port = 8080;
      db = {
        host = "10.0.20.50";
        dialect = "postgresql";
        username = "hedgedoc";
        database = "hedgedoc";
      };
    };
  };
}