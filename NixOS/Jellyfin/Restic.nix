{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/lib/jellyfin"
        "/var/lib/radarr/.config/Radarr"
        "/var/lib/sonarr/.config/NzbDrone"
      ];
    };
  };
}