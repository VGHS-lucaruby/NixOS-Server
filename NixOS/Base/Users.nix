{ config, ... }:

{
  users = {
    mutableUsers = true;
    users.root.password = "change";
    users.usrmgmt01 = {
      isNormalUser = true;
      extraGroups = [ "networkmanager" "wheel" "mgmnt" ];
    };
  };
}