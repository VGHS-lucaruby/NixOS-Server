{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/lib/teamspeak3-server"
      ];
    };
  };
}