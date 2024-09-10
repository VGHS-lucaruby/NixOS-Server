{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/srv/grafana"
      ];
    };
  };
}