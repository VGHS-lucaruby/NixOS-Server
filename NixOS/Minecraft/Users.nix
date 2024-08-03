{ lib, config, ... }:

{
  users.users.svcminecraft = {
    isNormalUser = true;
  };

  users.groups.minecraft.members = [ "svcminecraft" ];  
}