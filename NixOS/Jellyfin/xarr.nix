{ ... }:

{
  services = {
    radarr = {
      enable = true;
      openFirewall = true;
    };

    sonarr = {
      enable = true;
      openFirewall = true;
    };
  };
}
