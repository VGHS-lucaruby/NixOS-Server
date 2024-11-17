{ ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/prometheus 0700 prometheus prometheus - -" ];

  services.prometheus = {
    enable = true;
    stateDir = "prometheus";
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