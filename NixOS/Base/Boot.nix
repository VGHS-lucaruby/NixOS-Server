{ ... }:

{
  boot = {
    growPartition = true;
    kernelParams = [ "console=ttyS0" ];
    initrd.availableKernelModules = [ "uas" "virtio_blk" "virtio_pci" ];
    loader.grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };
}