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
    jvmOpts = "-Xms10G -Xmx10G -XX:+UseG1GCl -XX:MaxGCPauseMillis=20 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=1 -XX:G1HeapWastePercent=30 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99";
    serverProperties = {
        difficulty = 3;
        gamemode = 1;
        allow-flight = 1;
        motd = "Fabric Test Server";
      };
  };
}