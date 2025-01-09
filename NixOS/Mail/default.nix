{ inputs, lib, config, ... }:

{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
    ./Mail.nix
    ./Prometheus.nix
    ./Restic.nix
  ];
}