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

  # Enable Modules
  # Example: modMinecraft.enable = true;
}
