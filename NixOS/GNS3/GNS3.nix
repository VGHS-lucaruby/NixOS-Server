{ config, pkgs, ... }:

{
  sops.secrets = {
    "GNS3/password" = { owner = "gns3"; };
  };

  services.gns3-server = {  
    enable = true;
    auth = {
      enable = true;
      user = "gns3";
      passwordFile = config.sops.secrets."GNS3/password".path;
    };
    vpcs = {
      enable = true;
    };
    settings = {
      Server = {
        host = "0.0.0.0";
        port = 8080;
      };
    };
  };
}