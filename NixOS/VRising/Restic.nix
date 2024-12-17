{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/lib/SteamDownloader/1829350/save-data"
      ];
    };
  };
}