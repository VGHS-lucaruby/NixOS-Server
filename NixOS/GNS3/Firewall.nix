{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 
      80 # HTTP
    ];
  };
}