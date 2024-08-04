{ lib, config, ... }:

{
  imports = [
    ./Nix-Minecraft.nix
    ./WorldCreation2.0.nix
  ];
}