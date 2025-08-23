{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./Postgres.nix
    ./Prometheus.nix
    ./Restic.nix
  ];
}