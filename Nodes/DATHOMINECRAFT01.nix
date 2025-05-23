{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.101";
        prefixLength = 24;
      } 
    ];
  };

  # Import Modules
  imports = [ 
    ../NixOS/Minecraft 
    ../NixOS/Minecraft/Stitches-Pack.nix
  ];

  # Configure Modules
  # Example: modExample.enable = true;
}
