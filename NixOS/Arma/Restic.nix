{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/srv/steam-app*"
      ];
    };
  };
}