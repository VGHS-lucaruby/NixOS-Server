{ lib, ... }:

{
  options = {
    modRestic.enable = lib.mkEnableOption "Enables Restic Backups";
  };

  modRestic.enable = lib.mkDefault true;

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
    ./Qemu.nix
    ./Restic.nix
    ./Sops.nix
    ./SSH.nix
    ./Users.nix
    ./Zsh.nix
  ];
}