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
  imports = [ 
    ../NixOS/Arma
    ../NixOS/Teamspeak 
  ];

  # Configure Modules
  # Example: modExample.enable = true;
}
