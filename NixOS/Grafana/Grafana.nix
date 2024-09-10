{ config, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/grafanaAdmin" = {
      owner = "grafana";
    };
  };

  services.grafana = {
    enable = true;
    dataDir = "/srv/grafana";
    settings = {
      analytics = {
        check_for_plugin_updates = true;
      };
      security = {
        admin_user = "Admin";
        admin_password = "$__file{${config.sops.secrets."Passwords/grafanaAdmin".path}}";
      };
      server = {
        protocol = "http";
        http_port = 8443;
        http_addr = "10.0.20.53"; # Find a way to make this a little more dynamic
      };
    };
  };
}