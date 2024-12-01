{ config, allNodes, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/prometheus 0700 prometheus prometheus - -" ];

  # todo secure
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
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
    ];
  };
}