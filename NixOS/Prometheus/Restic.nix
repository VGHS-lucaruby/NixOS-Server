{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/lib/prometheus"
      ];
    };
  };
}