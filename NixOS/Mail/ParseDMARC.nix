{ sops, config, lib, primaryDomain, ... }:

{
  sops.secrets = {
    "Mail/dmarc-reports" = {};
    "Mail/maxmindLicence" = {};
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "elasticsearch"
  ];

  services = {
    parsedmarc = {
      enable = true;
      settings = {
        imap = {
          host = "mail.${primaryDomain}";
          user = "dmarc-reports@${primaryDomain}";
          password = "/run/credentials/parsedmarc.service/dmarcPassword";
        };
      };
    };

    geoipupdate = {
      settings = {
        AccountID = 995294;
        LicenseKey = "/run/credentials/geoipupdate.service/maxmindLicence";
      };
    };
  };
  systemd.services.parsedmarc.serviceConfig.LoadCredential = "dmarcPassword:${config.sops.secrets."Mail/dmarc-reports".path}";
  systemd.services.geoipupdate.serviceConfig.LoadCredential = "maxmindLicence:${config.sops.secrets."Mail/maxmindLicence".path}";
}