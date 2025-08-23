{ sops, config, lib, primaryDomain, ... }:

{
  services.prometheus.exporters.postgres = {
    enable = true;
    openFirewall = true;
  };
}