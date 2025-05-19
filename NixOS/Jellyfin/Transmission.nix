{ pkgs, ... }:

{
  services.transmission = {
    enable = true;
    openFirewall = true;
    webHome = pkgs.flood-for-transmission;
    openRPCPort = true;
    home = "/mnt/media/transmission";
    downloadDirPermissions = "770";
    group = "media"; 
    package = pkgs.transmission_4;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,10.0.*.*";
    };
  };
}