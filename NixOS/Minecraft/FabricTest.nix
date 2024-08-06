{ pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];
  services.minecraft-servers.servers.FabricTest = {
    enable = true;
    package = pkgs.fabricServers.fabric-1_20_1.override { 
      loaderVersion = "0.16.0"; 
      # jre_headless = pkgs.jdk17; 
    };
    jvmOpts = "-Xms10G -Xmx10G";
    serverProperties = {
        difficulty = 3;
        gamemode = 1;
        allow-flight = 1;
        motd = "Fabric Test Server";
      };
  };
}