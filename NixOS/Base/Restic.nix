{ config, lib, ... }:

{
  config = lib.mkIf config.modRestic.enable {

    sops.secrets = {
      "Restic/env" = {};
      "Restic/repo" = {};
      "Restic/password" = {};
    };

    services.restic.backups = {
      dailyBackup = {
        initialize = true;

        environmentFile = config.sops.secrets."Restic/env".path;
        repositoryFile = config.sops.secrets."Restic/repo".path;
        passwordFile = config.sops.secrets."Restic/password".path;

        # paths = [
        #   "/etc/ssh"
        # ];

        timerConfig = {
          OnCalendar = "21:00";
          Persistent = true;
          RandomizedDelaySec = "2h";
        };

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
      };
      
      weeklyCheck = {
        runCheck = true;

        environmentFile = config.sops.secrets."Restic/env".path;
        repositoryFile = config.sops.secrets."Restic/repo".path;
        passwordFile = config.sops.secrets."Restic/password".path;

        checkOpts = [
          "--read-data-subset=15%"
        ];
      
        timerConfig = {
          OnCalendar = "Sun *-*-* 03:00 Europe/London";
          Persistent = true;
        };
      };
    };

    # todo need to add email notifications on faliure of backup or check.

  };
}