{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 
      8080 # HTTP
    ];
  };
}