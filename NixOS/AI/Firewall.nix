{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      10200
      10300
    ];
  };
}