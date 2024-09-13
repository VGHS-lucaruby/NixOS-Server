{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    ./Authentik.nix
    ./Restic.nix
  ];
}