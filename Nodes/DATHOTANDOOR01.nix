{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.103";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ ../NixOS/Tandoor ];

  # Configure Modules
  # Example: modExample.enable = true;
}
