{ config, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/grafanaAdmin" = {
      owner = "grafana";
    };
  };

  services.grafana = {
    enable = true;
    dataDir = "/var/lib/grafana";
    settings = {
      analytics = {
        check_for_plugin_updates = true;
      };
      security = {
        admin_user = "Admin";
        admin_password = "$__file{${config.sops.secrets."Passwords/grafanaAdmin".path}}";
      };
      server = {
        protocol = "https";
        http_port = 8443;
        http_addr = "0.0.0.0";
      };
    };
  };
}