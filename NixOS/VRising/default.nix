{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./Restic.nix
    ./VRising.nix
  ];
}