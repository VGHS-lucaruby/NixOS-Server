{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./Prometheus.nix
    ./Restic.nix
  ];
}