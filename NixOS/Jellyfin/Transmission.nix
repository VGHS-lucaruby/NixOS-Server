{ pkgs, ... }:

{
  services.transmission = {
    enable = true;
    openFirewall = true;
    # webHome = pkgs.flood-for-transmission;
    home = "/mnt/media/transmission";
    downloadDirPermissions = "770";
    group = "media"; 
  };
}