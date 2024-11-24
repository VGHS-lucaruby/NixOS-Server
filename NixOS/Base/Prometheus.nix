{ config, lib, ... }:

{
  config = lib.mkIf config.modPrometheus.enable {
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
  };
}
