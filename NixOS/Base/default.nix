{ ... }:

{
  imports = [
    ./AutoUpgrade.nix
    ./Boot.nix
    ./Fail2Ban.nix
    ./FileSystem.nix
    ./Firewall.nix
    ./Locale.nix
    ./NixGC.nix
    ./Packages.nix
    ./Proxmox.nix
    ./SSH.nix
    ./Users.nix
    ./Zsh.nix
  ];
}