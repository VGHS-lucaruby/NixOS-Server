{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/var/mail"
        "/var/dkim"
        "/var/sieve"
      ];
    };
  };
}