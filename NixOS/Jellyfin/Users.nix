{ ... }:

{
  users = {
    groups = {
      media = {
        name = "media";
        members = [ "jellyfin" "radarr" "sonarr" "transmission" ];
      };
    };
  };
  
}