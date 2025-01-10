{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/vmail"
        "/var/dkim"
        "/var/sieve"
      ];
    };
  };
}