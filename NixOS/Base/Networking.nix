{ ... }:

{
  networking = {  
    networkmanager.enable = true;
    useDHCP = false;
    defaultGateway = {
      address = "10.0.20.254";
      interface = "eth0";
    };
    nameservers = [ "10.0.20.254" ];
  };
}