{ ... }:

{
  imports = [
    ./AutoUpgrade.nix
    ./Boot.nix
    ./FileSystem.nix
    ./Firewall.nix
    ./Locale.nix
    ./NixGC.nix
    ./Packages.nix
    ./Proxmox.nix
    ./Users.nix
    ./Zsh.nix
  ];
}