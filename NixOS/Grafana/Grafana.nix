{ config, pkgs, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/postgres" = { owner = "grafana"; };
    "Grafana/userAdmin" = { owner = "grafana"; };
    "Grafana/oauthClientID" = { owner = "grafana"; };
    "Grafana/oauthSecret" = { owner = "grafana"; };
  };

  services.grafana = {
    enable = true;
    dataDir = "/var/lib/grafana";
    declarativePlugins = with pkgs.grafanaPlugins; [ 
      grafana-oncall-app
    ];
    settings = {
      database = {
        host = "10.0.20.50:5432";
        type = "postgres";
        user = "grafana";
        password = "$__file{${config.sops.secrets."Passwords/postgres".path}}";
      };
      security = {
        admin_user = "Admin";
        admin_password = "$__file{${config.sops.secrets."Grafana/userAdmin".path}}";
      };
      server = {
        protocol = "https";
        http_port = 8443;
        http_addr = "0.0.0.0";
      };
      "auth.generic_oauth" = {
        name = "Authentik";
        enabled = true;
        allow_sign_up = true;
        client_id = "$__file{${config.sops.secrets."Grafana/oauthClientID".path}}";
        client_secret = "$__file{${config.sops.secrets."Grafana/oauthSecret".path}}";
        role_attribute_path = "contains(groups, 'grafana-admin') && 'Admin' || contains(groups, 'grafana-editor') && 'Editor' || 'Viewer'";
        role_attribute_strict = false;
        auth_url = "https://auth.${primaryDomain}/application/o/authorize/";
        token_url = "https://auth.${primaryDomain}/application/o/token/";
        api_url = "https://auth.${primaryDomain}/application/o/userinfo/";
        signout_redirect_url = "https://auth.${primaryDomain}/application/o/grafana/end-session/";
        use_pkce = true;
        allow_assign_grafana_admin = true;
        skip_org_role_sync = false;
        use_refresh_token = true;
      };     
    };
  };
}