{ ... }:

{
  imports = [
    ./Basepackages.nix
    ./Firewall.nix
    ./Locale.nix
    ./Network.nix
    ./QEMU.nix
    ./Users.nix
    ./Zsh.nix
  ];
}