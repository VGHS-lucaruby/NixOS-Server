{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.102";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ ../NixOS/AI ];

  # Configure Modules
  modGraphics.enable = true;
  modRestic.enable = false;
}
