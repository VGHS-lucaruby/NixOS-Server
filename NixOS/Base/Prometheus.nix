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
    };
  };
}
