{ inputs, ... }:

{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  let
    modpack = pkgs.fetchPackwizModpack {
      url = "https://raw.githubusercontent.com/VGHS-lucaruby/Minecraft-WorldCreation/master/pack.toml";
      packHash = "sha256-c587f7017cf7a0d175237d9695976e76d230320408447963ac4e0802b2ed4aba";
    };
    mcVersion = modpack.manifest.versions.minecraft;
    fabricVersion = modpack.manifest.versions.fabric;
    serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
  in
  {
    services.minecraft-servers.servers."WorldCreation2.0" = {
      enable = true;
      autoStart = true;
      restart = "always";

      package = pkgs.fabricServers.${serverVersion}.override { loaderVersion = fabricVersion; };
      symlinks = {
        "mods" = "${modpack}/mods";
        "config" = "${modpack}/config";
      };

      jvmOpts = "-Xms10G -Xmx10G -XX:+UseG1GCl -XX:MaxGCPauseMillis=20 -XX:+PerfDisableSharedMem -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=23 -XX:G1ReservePercent=20 -XX:SurvivorRatio=32 -XX:G1MixedGCCountTarget=1 -XX:G1HeapWastePercent=30 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1RSetUpdatingPauseTimePercent=0 -XX:MaxTenuringThreshold=1 -XX:G1SATBBufferEnqueueingThresholdPercent=30 -XX:G1ConcMarkStepDurationMillis=5.0 -XX:G1ConcRSHotCardLimit=16 -XX:G1ConcRefinementServiceIntervalMillis=150 -XX:GCTimeRatio=99";

      serverProperties = {
        difficulty = 3;
        allow-flight = 1;
        motd = "World Creation 2.0";
        white-list = true;
      };
    };
  }
}