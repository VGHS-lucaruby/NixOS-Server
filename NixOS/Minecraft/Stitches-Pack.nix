{ pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/Boxingflame/Stitches-Pack/1.1.0/pack.toml";
    packHash = "sha256-e1rK/9w3gMk/OalzNlyq/7aBSS09J+Pstqw57kWlHjQ=";
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
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UnlockDiagnosticVMOptions \
    -XX:+AlwaysActAsServerClassMachine \
    -XX:+AlwaysPreTouch \
    -XX:+DisableExplicitGC \
    -XX:+UseNUMA \
    -XX:AllocatePrefetchStyle=3 \
    -XX:NmethodSweepActivity=1 \
    -XX:ReservedCodeCacheSize=400M \
    -XX:NonNMethodCodeHeapSize=12M \
    -XX:ProfiledCodeHeapSize=194M \
    -XX:NonProfiledCodeHeapSize=194M \
    -XX:-DontCompileHugeMethods \
    -XX:+PerfDisableSharedMem \
    -XX:+UseFastUnorderedTimeStamps \
    -XX:+UseCriticalJavaThreadPriority \
    -XX:+EagerJVMCI
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
      jre_headless = pkgs.graalvm-ce;
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
      view-distance = 12;
      simulation-distance = 12;
    };
  };

  systemd.services.minecraft-server-Stitches-Pack = {
    preStart = "find logs -mindepth 1 -mtime +3 -delete -type f";
  };
}