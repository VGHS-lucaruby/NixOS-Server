{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 
      9443 # HTTPS
      6636 # LDAPS
      1812 # RADIUS
      9300 # Prometheus Metrics
    ];
    allowedUDPPorts = [ 
      1812 # RADIUS
    ];
  };
}