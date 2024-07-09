{ ... }:

{
  imports = [
    ./Firewall.nix
    ./Locale.nix
    ./Network.nix
    ./Packages.nix
    ./QEMU.nix
    ./Users.nix
    ./Zsh.nix
  ];
}