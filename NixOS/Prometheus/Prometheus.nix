{ config, allNodes, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/prometheus 0700 prometheus prometheus - -" ];

  sops.secrets = {
    "Prometheus/hassLongLived" = { owner = "prometheus"; };
  };

  # todo secure
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
    checkConfig = "syntax-only";
    scrapeConfigs = [
      {
        job_name = "node-static";
        static_configs = [{
          targets = [ "10.0.20.254:9100" ];
          labels = { instance = "DATHOOPNS01"; };
        }];
      }
      {
        job_name = "node-dns";
        dns_sd_configs = [{
          names = (map (node: "${node}.server.arpa") allNodes);
          type = "A";
          port = 9100;
        }];
        relabel_configs = [{
          source_labels = [ "__meta_dns_name" ];
          regex = "([^\.]+)\..+";
          target_label = "instance";
        }];
      }
      {
        job_name = "hass";
        metrics_path = "/api/prometheus";
        authorization = { credentials_file = config.sops.secrets."Prometheus/hassLongLived".path; };
        scheme = "http";
        static_configs = [{
          targets = [ "10.0.20.100:8123" ];
          labels = { instance = "DATHOHOMEASST01"; };
        }];
      }
    ];
  };
}