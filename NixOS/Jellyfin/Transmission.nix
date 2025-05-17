{ pkgs, ... }:

{
  services.transmission = {
    enable = true;
    openFirewall = true;
    webHome = pkgs.flood-for-transmission;
    settings = {
      download-dir = "/mnt/media";
    };
  };
}