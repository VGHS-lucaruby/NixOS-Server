{ config, lib, ... }:

{
  # todo security
  services.prometheus = {
    exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        openFirewall = true;
      };
      restic = lib.mkIf config.modRestic.enable {
        enable = true;
        openFirewall = true;
        refreshInterval = 21600;
        environmentFile = config.sops.secrets."Restic/env".path;
        repositoryFile = config.sops.secrets."Restic/repo".path;
        passwordFile = config.sops.secrets."Restic/password".path;
      };
    };
  };
}
