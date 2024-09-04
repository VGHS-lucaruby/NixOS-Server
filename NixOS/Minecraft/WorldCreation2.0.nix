{ pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/VGHS-lucaruby/Minecraft-WorldCreation/2.0.1/pack.toml";
    packHash = "sha256-YLuadlNr/CNW1R7FLrqvw/QdWPl5Tbpv0fIAuEeIDm4=";
  };

  mcVersion = modpack.manifest.versions.minecraft;
  fabricVersion = modpack.manifest.versions.fabric;
  serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
in {

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  services.minecraft-servers.servers."WorldCreation2.0" = {
    enable = true;

    package = pkgs.fabricServers.${serverVersion}.override { 
      loaderVersion = fabricVersion; 
      # jre_headless = pkgs.jdk17; 
    };
    symlinks = {
      "mods" = "${modpack}/mods";
      # "defaultconfigs" = "${modpack}/config";
    };
    
    files = {
      "config/tectonic.json" = "${modpack}/config/tectonic.json";
      "config/textile_backup.json5" = "${modpack}/config/textile_backup.json5";
      "config/gravestones.json" = "${modpack}/config/gravestones.json";
      "config/openpartiesandclaims-server.toml" = "${modpack}/config/openpartiesandclaims-server.toml";
    };

    jvmOpts = "-Xms10G -Xmx10G";
    serverProperties = {
      difficulty = 3;
      allow-flight = 1;
      motd = "World Creation 2.0";
      white-list = true;
      level-seed = 399944747049512087;
      level-name = "WorldCreation2.0";
    };
  };
  
  # Backup to B2 
  services.restic.backups = {
    daily = {
      paths = [
        "/srv/minecraft/WorldCreation2.0"
      ];
    };
  };
}