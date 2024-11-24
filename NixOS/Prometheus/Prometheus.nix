{ ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/prometheus 0700 prometheus prometheus - -" ];

  # todo secure
  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
    scrapeConfigs = [
      {
        # Initial Node For Testing. Will Attempt To Make Config Dynamic In Future.
        job_name = "DATHOMINECRAFT01";
        static_configs = [{
          targets = [ "10.0.20.101:9100" ];
        }];
      }
    ];
  };
}