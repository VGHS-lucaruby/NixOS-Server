{ inputs, lib, config, ... }:

{
  imports = [
    inputs.authentik-nix.nixosModules.default
    ./Firewall.nix
    ./HedgeDoc.nix
    ./Restic.nix
  ];
}