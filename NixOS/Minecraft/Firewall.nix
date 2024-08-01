{ lib, config, ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    networking.firewall = {
      allowedTCPPorts = [25565 25575];
      allowedUDPPorts = [25565 25575];
    };
  };
}