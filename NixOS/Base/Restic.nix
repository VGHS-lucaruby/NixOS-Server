{ config, lib, ... }:

{
  config = lib.mkIf config.modRestic.enable {

    sops.secrets = {
      "Restic/env" = {};
      "Restic/repo" = {};
      "Restic/password" = {};
    };

    services.restic.backups = {
      daily = {
        initialize = true;

        environmentFile = config.sops.secrets."Restic/env".path;
        repositoryFile = config.sops.secrets."Restic/repo".path;
        passwordFile = config.sops.secrets."Restic/password".path;

        paths = [
          "/etc/ssh"
        ];

        timerConfig = {
          OnCalendar = "22:00";
          Persistent = true;
          RandomizedDelaySec = "2h";
        };

        pruneOpts = [
          "--keep-daily 7"
          "--keep-weekly 5"
          "--keep-monthly 12"
        ];
      };
    };
  };
}