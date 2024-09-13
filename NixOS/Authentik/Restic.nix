{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/srv/postgresql"
      ];
    };
  };
}