{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    label = "NIXROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "NIXBOOT";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}