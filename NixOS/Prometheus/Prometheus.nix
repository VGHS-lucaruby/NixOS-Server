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
    extraFlags = [ "--storage.tsdb.retention.time 2y" ];
    exporters = {
      snmp = {
        enable = true;
        openFirewall = true;
        configurationPath = ./snmp.yml;
      };
    };
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
        job_name = "restic";
        dns_sd_configs = [{
          names = (map (node: "${node}.server.arpa") allNodes);
          type = "A";
          port = 9753;
        }];
        relabel_configs = [{
          source_labels = [ "__meta_dns_name" ];
          regex = "([^\.]+)\..+";
          target_label = "instance";
        }];
      }
      {
        job_name = "authentik";
        dns_sd_configs = [{
          names = [ "DATHOAUTHENTIK01.server.arpa" ];
          type = "A";
          port = 9300;
        }];
        relabel_configs = [{
          source_labels = [ "__meta_dns_name" ];
          regex = "([^\.]+)\..+";
          target_label = "instance";
        }];
      }
      # {
      #   job_name = "dmarc";
      #   dns_sd_configs = [{
      #     names = [ "DATHOMAIL01.server.arpa" ];
      #     type = "A";
      #     port = 9797;
      #   }];
      #   relabel_configs = [{
      #     source_labels = [ "__meta_dns_name" ];
      #     regex = "([^\.]+)\..+";
      #     target_label = "instance";
      #   }];
      # }
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
      {
        job_name = "snmp-ilo";
        metrics_path = "/snmp";
        static_configs = [{
          targets = [ "10.0.20.11" ];
        }];
        params = {
          auth = [ "public_v2" ];
          module = [
            "if_mib"
            "hpe"
          ];
        };
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:9116";
          }
        ];
      }
            {
        job_name = "snmp-unifi";
        metrics_path = "/snmp";
        static_configs = [{
          targets = [ 
            "10.0.0.252"
            "10.0.0.251"
            "10.0.0.240"
            "10.0.0.239"
          ];
        }];
        params = {
          auth = [ "public_v2" ];
          module = [
            "if_mib"
            "ubiquiti_unifi"
          ];
        };
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            target_label = "__param_target";
          }
          {
            source_labels = [ "__param_target" ];
            target_label = "instance";
          }
          {
            target_label = "__address__";
            replacement = "127.0.0.1:9116";
          }
        ];
      }
      {
        job_name = "snmp_exporter";
        static_configs = [{
          targets = [ "localhost:9116" ];
        }];
      }
    ];
  };
}