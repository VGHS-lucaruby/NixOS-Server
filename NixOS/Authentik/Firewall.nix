{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [9443 6636 9300 3389];
  };
}