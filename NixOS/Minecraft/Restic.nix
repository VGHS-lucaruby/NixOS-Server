{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      exclude = [
        "/srv/minecraft/*/backup"
        "/srv/minecraft/*/crash-reports"
        "/srv/minecraft/*/logs"
        "/srv/minecraft/*/libraries"
        "/srv/minecraft/*/eula.txt"
      ];
      paths = [
        "/srv/minecraft/*"
      ];
    };
  };
}