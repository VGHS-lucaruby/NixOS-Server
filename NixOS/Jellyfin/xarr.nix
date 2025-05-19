{ ... }:

{
  services = {
    radarr = {
      enable = true;
      openFirewall = true;
      group = "media"; 
    };

    sonarr = {
      enable = true;
      openFirewall = true;
      group = "media"; 
    };
  };
}
