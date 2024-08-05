{ pkgs, ... }:

{
  services.minecraft-servers.servers.PaperTest = {
    enable = true;
    package = pkgs.paperServers.paper-1_20_1;
    jvmOpts = "-Xms10G -Xmx10G";
    serverProperties = {
        difficulty = 3;
        gamemode = 1;
        allow-flight = 1;
        motd = "Paper Test Server";
      };
  };
}