{ ... }:

{
  imports = [
    ./Boot.nix
    ./Firewall.nix
    ./Locale.nix
    ./Network.nix
    ./NixGC.nix
    ./Packages.nix
    ./QEMU.nix
    ./Users.nix
    ./Zsh.nix
  ];
}