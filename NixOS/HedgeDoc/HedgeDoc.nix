{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "HedgeDoc/env" = { owner = "hedgedoc"; };
  };

  services.hedgedoc = {
    enable = true;
    environmentFile = config.sops.secrets."HedgeDoc/env".path;
    settings = {
      domain = "notes.${primaryDomain}";
      host = "0.0.0.0";
      port = 8080;
      protocolUseSSL = true;
      allowAnonymous = false;
      allowAnonymousEdits = true;
      defaultPermission = "limited";
      # Using OAuth for login, settings reside in ENV file
      email = false;
      allowEmailRegister = false;
      db = {
        host = "10.0.20.50";
        dialect = "postgresql";
        username = "hedgedoc";
        database = "hedgedoc";
      };
    };
  };
}