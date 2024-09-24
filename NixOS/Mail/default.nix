{ inputs, lib, config, ... }:

{
  imports = [
    inputs.simple-nixos-mailserver.nixosModule
    ./Mail.nix
    ./Restic.nix
  ];
}