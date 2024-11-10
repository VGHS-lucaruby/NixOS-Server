{ ... }:

{
  services.prometheus = {
    enable = true;
    stateDir = "/var/lib/prometheus";
    # alertmanager = {
    #   enable = true;
    #   listenAddress = "0.0.0.0";
    # };
    # exporters = {
    #   snmp = {
    #     enable = true;
    #   };
    # };
  };
}