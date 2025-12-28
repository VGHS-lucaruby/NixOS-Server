{ config, ... }:

{
  services.restic.backups = {
    dailyBackup = {
      paths = [
        "${config.services.hedgedoc.settings.uploadsPath}"
      ];
    };
  };
}