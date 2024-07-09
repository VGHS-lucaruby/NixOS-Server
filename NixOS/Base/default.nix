{ ... }:

{
  imports = [
    ./Firewall.nix
    ./Grub.nix
    ./Locale.nix
    ./Network.nix
    ./Packages.nix
    ./QEMU.nix
    ./Users.nix
    ./Zsh.nix
  ];
}