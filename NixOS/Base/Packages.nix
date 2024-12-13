{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    ssh-to-age
    wget
    pciutils
    sl
    htop
    bottom
    glances
    fastfetch
    nano
    tmux
    iperf
  ];
}