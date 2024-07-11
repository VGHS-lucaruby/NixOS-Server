{ config, lib, pkgs, ... }:

{
  fileSystems."/" = {
    label = "NIXOS-ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "NIXOS-BOOT";
    fsType = "vfat";
    option = [ "fmask=0077" "dmask=0077"];
  };

  swapDevices = [ 
    { label = "NIXOS-SWAP"; } 
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}