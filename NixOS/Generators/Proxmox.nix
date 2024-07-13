{ pkgs, ... }:

{
  fileSystems."/" = {
    label = "nixos";
    autoResize = true;
    fsType = "ext4";
  };

  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0" ];
    kernelPackages = pkgs.linuxPackages_latest;
    availableKernelModules = [ "uas" "virtio_blk" "virtio_pci" "virtio_scsi" "uhci_hcd" "ehci_pci" "ahci" "sd_mod" "sr_mod" ];
    loader.grub = {
      device = "/dev/vda";
      efiSupport = false;
      efiInstallAsRemovable = false;
    };
  };
}