{ lib, config, ... }:

{
  options = {
    modRestic.enable = lib.mkEnableOption "Enables Restic Backups";
    modSteamDownloader.enable = lib.mkEnableOption "Enables Steam Downloader Service";
    modGraphics.enable = lib.mkEnableOption "Enables Graphic Settings With Settings For AMD Hosts";
  };

  config.modRestic.enable = lib.mkDefault true;

  imports = [
    ./AutoUpgrade.nix
    ./Boot.nix
    ./Fail2Ban.nix
    ./FileSystem.nix
    ./Firewall.nix
    ./Graphics.nix
    ./LDAP.nix
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