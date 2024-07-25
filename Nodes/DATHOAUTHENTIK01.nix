{ ... }:

{
  # Set IP
  networking = {  
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.51";
        prefixLength = 24;
      } 
    ];
  };

  # Enable Modules
  # Example: modMinecraft.enable = true;
}
