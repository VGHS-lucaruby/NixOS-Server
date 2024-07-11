{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.growPartition = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.timeout = 0;
}