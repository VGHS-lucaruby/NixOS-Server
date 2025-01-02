{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.57";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ ../NixOS/GNS3 ];

  # Configure Modules
  # Example: modExample.enable = true;
}
