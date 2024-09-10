{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./Grafana.nix
    ./Restic.nix
  ];
}