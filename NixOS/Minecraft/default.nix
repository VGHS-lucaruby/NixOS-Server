{ inputs, lib, pkgs, ... }:

{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    ./Nix-Minecraft.nix
    ./PaperTest.nix
  ];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];
}