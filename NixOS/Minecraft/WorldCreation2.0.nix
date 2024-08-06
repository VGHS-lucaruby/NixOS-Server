{ pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/VGHS-lucaruby/Minecraft-WorldCreation/2.0.0-RC5/pack.toml";
    packHash = "sha256-Eom5FLZAPvOcE9zzzysFB25x9Cpkeo+ftVMDTv2BN50=";
  };

  # mcVersion = modpack.manifest.versions.minecraft;
  # fabricVersion = modpack.manifest.versions.fabric;
  # serverVersion = lib.replaceStrings [ "." ] [ "_" ] "fabric-${mcVersion}";
in {

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "minecraft-server"
  ];

  services.minecraft-servers.servers."WorldCreation2.0" = {
    enable = true;
    autoStart = true;
    restart = "always";

    package = pkgs.fabricServers.fabric-1_20_1.override { 
      loaderVersion = "0.16.0"; 
      # jre_headless = pkgs.jdk17; 
    };
    symlinks = {
      "mods" = "${modpack}/mods";
      # "config" = "${modpack}/config";
    };

    jvmOpts = "-Xms10G -Xmx10G";
    serverProperties = {
      difficulty = 3;
      allow-flight = 1;
      motd = "World Creation 2.0";
      white-list = true;
    };
  };
}