{ ... }:

{
  imports = [
    ./Firewall.nix
    ./Jellyfin.nix
    ./Jellyseerr.nix
    ./Restic.nix
    ./Transmission.nix
    ./Users.nix
    ./xarr.nix
  ];
}