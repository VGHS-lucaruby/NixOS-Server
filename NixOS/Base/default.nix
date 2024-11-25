{ lib, config, ... }:

{
  options = {
    modRestic.enable = lib.mkEnableOption "Enables Restic Backups";
    modSteamDownloader.enable = lib.mkEnableOption "Enables Steam Downloader Service";
  };

  config.modRestic.enable = lib.mkDefault true;

  imports = [
    ./AutoUpgrade.nix
    ./Boot.nix
    ./Fail2Ban.nix
    ./FileSystem.nix
    ./Firewall.nix
    ./Locale.nix
    ./Networking.nix
    ./NixGC.nix
    ./Packages.nix
    ./Prometheus.nix
    ./Qemu.nix
    ./Restic.nix
    ./Sops.nix
    ./SSH.nix
    ./SteamDownloader.nix
    ./Users.nix
    ./Zsh.nix
  ];
}