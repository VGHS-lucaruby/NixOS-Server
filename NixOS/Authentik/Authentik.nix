{ config, pkgs, ... }:

{
  sops.secrets = {
    "Authentik/env" = { owner = "authentik"; };
    "Authentik/envLDAP" = { owner = "authentik"; };
    "Authentik/envRADIUS" = { owner = "authentik"; };
  };

  services.authentik = {
    enable = true;
    environmentFile = config.sops.secrets."Authentik/env".path;
    createDatabase = false;
    settings = {
      postgresql = {
        user = "authentik";
        name = "authentik";
        host = "10.0.20.50";
      };
      # email = {
      #   host = "smtp.example.com";
      #   port = 587;
      #   username = "authentik@example.com";
      #   use_tls = true;
      #   use_ssl = false;
      #   from = "authentik@example.com";
      # };
      disable_startup_analytics = true;
      avatars = "initials";
    };
  };
}