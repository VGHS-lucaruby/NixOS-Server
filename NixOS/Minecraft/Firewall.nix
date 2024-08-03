{ lib, config, ... }:

{
  networking.firewall = {
    allowedTCPPorts = [25565 25575];
    allowedUDPPorts = [25565 25575];
  };
}