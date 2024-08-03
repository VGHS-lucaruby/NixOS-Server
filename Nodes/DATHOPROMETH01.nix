{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.54";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  # Example: imports = [ ../NixOS/Minecraft ];

  # Configure Modules
  # Example: modExample.enable = true;
}
