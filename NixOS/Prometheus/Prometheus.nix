{ config, allNodes, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/prometheus 0700 prometheus prometheus - -" ];

  # todo secure
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
    scrapeConfigs = [
      # {
      #   # Initial Node For Testing. Will Attempt To Make Config Dynamic In Future.
      #   job_name = "DATHOMINECRAFT01";
      #   static_configs = [{
      #     targets = [ "10.0.20.101:9100" ];
      #   }];
      # }
      {
        job_name = "node-dns";
        dns_sd_configs = [{
          names = map (node: "${node}.server.arpa") allNodes;
          type = "A";
          port = 9100;
        }];
        relabel_configs = [{
          source_labels = [ "__meta_dns_name" ];
          regex = "^(.+?)\.";
          target_label = "instance";
        }];
      }
    ];
  };
}