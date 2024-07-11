{ config, ... }:

{
  fileSystems."/" = {
    label = "NIXOS-ROOT";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "NIXOS-BOOT";
    fsType = "vfat";
    options = [ "umask=0077"];
  };

  swapDevices = [ 
    { label = "NIXOS-SWAP"; } 
  ];
}