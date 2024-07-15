{ ... }:

{
  proxmox.qemuConf.bios = "ovmf";
  services.cloud-init = {
    enable = true;
    network.enable = true;
    ext4.enable = true;
  };
}