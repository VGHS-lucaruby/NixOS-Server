{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.52";
        prefixLength = 24;
      } 
    ];
    interfaces.eth1.ipv4.addresses = [ 
      {
        address = "10.0.254.1";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ ../NixOS/Unifi ];

  # Configure Modules
  # Example: modExample.enable = true;
}