{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      8080
      10200
      11434
    ];
  };
}