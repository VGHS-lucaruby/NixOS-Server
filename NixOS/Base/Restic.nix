{ config, ... }:

{
  services.restic.backups = {
    daily = {
      initialize = true;
      
      environmentFile = config.sops.secrets."Restic/env".path;
      repositoryFile = config.sops.secrets."Restic/repo".path;
      passwordFile = config.sops.secrets."Restic/password".path;

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}