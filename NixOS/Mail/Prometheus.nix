{ sops, config, lib, primaryDomain, ... }:
# Broken... Unsure why.
{
  sops.secrets = {
    "Mail/dmarc-reports" = {};
  };

  services.prometheus = {
    exporters = {
      dmarc = {
        enable = true;
        debug = true;
        openFirewall = true;
        pollIntervalSeconds = 600;
        imap = {
          host = "mail.${primaryDomain}";
          username = "dmarc-reports@${primaryDomain}";
          passwordFile = "/run/credentials/prometheus-dmarc-exporter.service/dmarcPassword";
        };
      };
    };
  };
  systemd.services.prometheus-dmarc-exporter.serviceConfig.LoadCredential = "dmarcPassword:${config.sops.secrets."Mail/dmarc-reports".path}";
}