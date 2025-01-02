{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./GNS3.nix
    ./Restic.nix
  ];
}