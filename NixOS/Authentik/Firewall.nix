{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 
      9443 # HTTPS
      6636 # LDAPS
      9300 # Prometheus Metrics
    ];
    allowedUDPPorts = [ 
      1812 # RADIUS
      1813 # RADIUS Accounting.
    ];
  };
}