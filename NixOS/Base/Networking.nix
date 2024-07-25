{ ... }:

{
  networking = {  
    networkmanager.enable = true;
    enableIPv6 = false;
    defaultGateway = {
      address = "10.0.20.254";
      interface = "eth0";
    };
    nameservers = [ "10.0.20.254" ];
  };
}