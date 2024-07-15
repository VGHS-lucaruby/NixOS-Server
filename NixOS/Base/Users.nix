{ config, ... }:

{
  users = {
    mutableUsers = true;
    users.root.password = "change"; # todo replace with sops or equvilant 
    users.usrmgmt01 = {
      isNormalUser = true;
      password = "change"; # todo replace with sops or equvilant 
      extraGroups = [ "networkmanager" "wheel" "mgmnt" ];
      openssh.authorizedKeys.keys ={
        "" # todo add later
      };
    };
  };
}