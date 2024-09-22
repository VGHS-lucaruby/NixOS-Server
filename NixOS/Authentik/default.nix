{ inputs, lib, config, ... }:

{
  imports = [
    inputs.authentik-nix.nixosModules.default
    ./Firewall.nix
    ./Authentik.nix
    ./Restic.nix
  ];
}