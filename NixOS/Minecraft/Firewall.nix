{ lib, config, ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    networking.firewall = {
      allowedTCPPorts = [25565];
      allowedUDPPorts = [25565];
    };
  };
}