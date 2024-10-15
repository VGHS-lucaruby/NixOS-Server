{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      30033
    ];
    allowedUDPPorts = [
      9987
    ];
  };
}