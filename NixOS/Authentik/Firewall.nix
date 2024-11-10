{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [ 9443 3389 9300 ];
  };
}