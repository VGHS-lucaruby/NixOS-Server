{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    wget
    pciutils
    sl
    htop
    bottom
    glances
    fastfetch
    nano
  ];
}