{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "[Node IP Address]";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  # Example: imports = [ ../NixOS/Minecraft ];

  # Configure Modules
  # Example: modExample.enable = true;
}
