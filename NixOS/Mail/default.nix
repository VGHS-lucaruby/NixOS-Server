{ inputs, lib, config, ... }:

{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
    ./Firewall.nix
    ./Mail.nix
    ./ParseDMARC.nix
    # ./Prometheus.nix
    ./Restic.nix
  ];
}