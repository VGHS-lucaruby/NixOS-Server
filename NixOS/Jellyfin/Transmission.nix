{ pkgs, ... }:

{
  services.transmission = {
    enable = true;
    openFirewall = true;
    webHome = pkgs.flood-for-transmission;
  };
}