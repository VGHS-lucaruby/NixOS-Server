{ ... }:

{
  # Set IP
  networking = {  
    networkmanager.enable = true;
    interfaces.eth0.ipv4.addresses = [ 
      {
        address = "10.0.20.54";
        prefixLength = 24;
      } 
    ];
    defaultGateway = {
      address = "10.0.20.254";
      interface = "eth0";
    };
    nameservers = [ "10.0.20.254" ];
  };

  # Enable Modules
  # Example: modMinecraft.enable = true;
}
