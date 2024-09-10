{ lib, config, ... }:

{
  imports = [
    ./Grafana.nix
    ./Restic.nix
  ];
}