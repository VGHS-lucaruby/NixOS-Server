{ nodeHostName, ... }:

{
  proxmox = {
    qemuConf = {
      bios = "ovmf";
      name = nodeHostName;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr1,firewall=1,tag=20";
    };
  };
}