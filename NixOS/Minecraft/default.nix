{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./Nix-Minecraft.nix
    ./WorldCreation2.0.nix
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
}