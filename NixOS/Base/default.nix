{ ... }:

{
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
    ./SSH.nix
    ./Users.nix
    ./Zsh.nix
  ];
}