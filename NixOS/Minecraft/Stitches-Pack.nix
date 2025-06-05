{ pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/Boxingflame/Stitches-Pack/1.1.1/pack.toml";
    packHash = "sha256-69ZUVgjEaRViKn74+BmLptX7S5w+v/cSmUf3ybPTi2U=";
  };

  customPkgs = import ../../CustomPackages { inherit pkgs; };
  overlays = [
    (self: super: {
      forgeServers = customPkgs.forgeServers;
    })
  ];

  jvmArgs = ''
    -Xms12G \
    -Xmx12G \
    -XX:+UseG1GC \
    -XX:+ParallelRefProcEnabled \
    -XX:MaxGCPauseMillis=200 \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+DisableExplicitGC \
    -XX:+AlwaysPreTouch \
    -XX:G1NewSizePercent=30 \
    -XX:G1MaxNewSizePercent=40 \
    -XX:G1HeapRegionSize=8M \
    -XX:G1ReservePercent=20 \
    -XX:G1HeapWastePercent=5 \
    -XX:G1MixedGCCountTarget=4 \
    -XX:InitiatingHeapOccupancyPercent=15 \
    -XX:G1MixedGCLiveThresholdPercent=90 \
    -XX:G1RSetUpdatingPauseTimePercent=5 \
    -XX:SurvivorRatio=32 \
    -XX:+PerfDisableSharedMem \
    -XX:MaxTenuringThreshold=1 \
    -Dusing.aikars.flags=https://mcflags.emc.gs \
    -Daikars.new.flags=true
  '';

  mcVersion = modpack.manifest.versions.minecraft;
  forgeVersion = modpack.manifest.versions.forge;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "forge-${mcVersion}";
in {
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "forge-loader"
  ];

  nixpkgs.overlays = overlays;

  services.minecraft-servers.servers."Stitches-Pack" = {
    enable = true;

    package = pkgs.forgeServers.${serverVersion}.override { 
      loaderVersion = forgeVersion;
      jre_headless = pkgs.jdk17_headless;
    };

    symlinks = {
      "mods" = "${modpack}/mods";
    };
    
    files = {
      "config/aether-client.toml" = "${modpack}/config/aether-client.toml";
      "config/iceandfire-common.toml" = "${modpack}/config/iceandfire-common.toml";
      "config/quark-common.toml" = "${modpack}/config/quark-common.toml";
      "config/sparsestructures.json5" = "${modpack}/config/sparsestructures.json5";
      "config/waystones-common.toml" = "${modpack}/config/waystones-common.toml";
      "config/openpartiesandclaims-server.toml" = "${modpack}/config/openpartiesandclaims-server.toml";
    };

    jvmOpts = jvmArgs;
    serverProperties = {
      difficulty = 3;
      allow-flight = 1;
      motd = "Stitches Pack";
      white-list = true;
      level-seed = -2674564933958639869;
      level-name = "Stitches-Pack";
      view-distance = 8;
      simulation-distance = 6;
    };
  };

  systemd.services.minecraft-server-Stitches-Pack = {
    preStart = "find logs -mindepth 1 -mtime +3 -delete -type f";
  };
}