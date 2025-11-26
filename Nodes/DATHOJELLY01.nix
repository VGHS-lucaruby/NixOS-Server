{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.105";
        prefixLength = 24;
      } 
    ];
  };

  fileSystems."/mnt/media" = {
      device = "/dev/disk/by-uuid/2a5bad0a-ab80-425b-b317-6974c936e390";
      fsType = "ext4";
  };

  # Import Modules
  imports = [ ../NixOS/Jellyfin ];

  # Configure Modules
  modGraphics.enable = true;
}
