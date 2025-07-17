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
      restic = {
        enable = true;
        openFirewall = true;
        environmentFile = config.sops.secrets."Restic/env".path;
        repositoryFile = config.sops.secrets."Restic/repo".path;
        passwordFile = config.sops.secrets."Restic/password".path;
      };
    };
  };
}
