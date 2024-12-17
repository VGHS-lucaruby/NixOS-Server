{ lib, config, ... }:

{
  imports = [
    ./Arma.nix
    ./Firewall.nix
    ./Restic.nix
  ];
}