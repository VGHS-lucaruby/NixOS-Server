{ config, ... }:

{
  users.users.svcminecraft = {
    isNormalUser = true;
  };

  users.groups.minecraft.members = [ "usrmgmt01" "svcminecraft" ];
}