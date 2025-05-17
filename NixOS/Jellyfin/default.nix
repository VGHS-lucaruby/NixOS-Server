{ ... }:

{
  imports = [
    ./Jellyfin.nix
    ./Jellyseerr.nix
    ./Restic.nix
    ./Users.nix
    ./xarr.nix
  ];
}