{ ... }:

{
  networking.firewall = {
    allowedTCPPorts = [
      2344
      2345
    ];
    allowedUDPPorts = [
      2302
      2303
      2304
      2305
      2306
      2344
    ];
  };
}