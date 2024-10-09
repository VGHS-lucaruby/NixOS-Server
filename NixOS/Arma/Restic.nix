{ ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "/home/steam/.local/share/Arma 3 - Other Profiles"
      ];
    };
  };
}