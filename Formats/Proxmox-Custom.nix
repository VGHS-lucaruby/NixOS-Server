{ config, modulesPath, specialArgs, nodeHostName, ... }: 

{
  imports = [
    "${toString modulesPath}/virtualisation/proxmox-image.nix"
  ];

  # Default settings for new VM's
  # These are to be managed in Proxmox after initial setup
  # This is just to give a sane starting point for my setup.
  proxmox = {
    qemuConf = {
      bios = "ovmf";
      name = nodeHostName;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr1,firewall=1,tag=20";
      diskSize = "32768"; # Saneish default, maybe a little big for most things though saves me having to resize each new VM.
      # Set Cores and RAM to a default that allows rebuilding and is good enough for most of my uses as I keep forgetting... lol
      cores = 2;
      memory = 4096;
    };
  };

  formatAttr = "VMA";
  fileExtension = ".vma.zst";

  modGenerator.enable = true;
}