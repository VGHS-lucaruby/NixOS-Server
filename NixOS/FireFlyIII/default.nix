{ lib, config, ... }:

{
  imports = [
    ./FireFlyIII.nix
    ./Firewall.nix
    ./Restic.nix
  ];
}