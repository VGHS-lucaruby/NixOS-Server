{ pkgs, lib, ... }:

let
  modpack = pkgs.fetchPackwizModpack {
    url = "https://raw.githubusercontent.com/Boxingflame/Stitches-Pack/1.0.0-alpha.3/pack.toml";
    packHash = "sha256-ND+6d+VXYksVCrT89POXUqc7UUUx+FGR6tqdvQIbedU=";
  };

  customPkgs = import ../../CustomPackages { inherit pkgs; };
  overlays = [
    (self: super: {
      forgeServers = customPkgs.forgeServers;
    })
  ];

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
    };

    jvmOpts = "-Xms10G -Xmx10G";
    serverProperties = {
      difficulty = 3;
      allow-flight = 1;
      motd = "Stitces Pack";
      white-list = true;
      level-seed = -4858371721717382064;
      level-name = "Stitches-Pack";
    };
  };
}