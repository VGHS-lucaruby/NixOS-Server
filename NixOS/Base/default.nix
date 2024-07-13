{ ... }:

{
  imports = [
    ./AutoUpgrade.nix
    ./Firewall.nix
    ./Locale.nix
    ./NixGC.nix
    ./Packages.nix
    ./QEMU.nix
    ./Users.nix
    ./Zsh.nix
  ];
}