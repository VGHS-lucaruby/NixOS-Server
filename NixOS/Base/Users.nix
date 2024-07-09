{ config, ... }:

{
  users.users.usrmgmt01 = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}