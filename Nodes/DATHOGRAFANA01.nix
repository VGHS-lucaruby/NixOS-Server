{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.53";
        prefixLength = 24;
      } 
    ];
  };

  # Enable Modules
  # Example: modMinecraft.enable = true;
}
