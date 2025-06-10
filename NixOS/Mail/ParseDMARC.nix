{ sops, config, lib, primaryDomain, ... }:

{
  sops.secrets = {
    "Mail/dmarc-reports" = {};
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "elasticsearch"
  ];

  services.parsedmarc = {
    enable = true;
    settings = {
      imap = {
        host = "mail.${primaryDomain}";
        user = "dmarc-reports@${primaryDomain}";
        password = "/run/credentials/parsedmarc.service/dmarcPassword";
      };
    };
    provision.geoIp = false;
  };
  systemd.services.parsedmarc.serviceConfig.LoadCredential = "dmarcPassword:${config.sops.secrets."Mail/dmarc-reports".path}";
}