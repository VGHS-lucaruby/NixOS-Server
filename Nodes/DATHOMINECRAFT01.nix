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
    defaultGateway = "10.0.20.254";
    nameservers = [ "10.0.20.254" ];
  };
  
  # Enable Modules
  modMinecraft.enable = true;
}
