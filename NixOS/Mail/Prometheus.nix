{ sops, config, lib, primaryDomain, ... }:

{
  sops.secrets = {
    "Mail/dmarc-reports" = {};
  };

  services.prometheus = {
    exporters = {
      dmarc = {
        enable = true;
        openFirewall = true;
        pollIntervalSeconds = 600;
        imap = {
          host = "mail.${primaryDomain}";
          username = "dmarc-reports@${primaryDomain}";
          passwordFile = "/run/credentials/prometheus-dmarc-exporter.service/password";
        };
      };
    };
  };
  systemd.services.prometheus-dmarc-exporter.serviceConfig.LoadCredential = "password:${config.sops.secrets."Mail/dmarc-reports".path}";
}