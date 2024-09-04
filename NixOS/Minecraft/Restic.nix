{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      exclude = [
        "/srv/minecraft/*/backup"
      ];
      paths = [
        "/srv/minecraft/*"
      ];
    };
  };
}