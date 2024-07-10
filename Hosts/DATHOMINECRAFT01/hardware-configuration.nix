{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    label = "NIXOS-ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "NIXOS-BOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}