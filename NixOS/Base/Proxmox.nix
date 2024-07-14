{ ... }:

{
  proxmox.qemuConf.bios = "ovmf";
  services.cloud-init.network.enable = true;
}