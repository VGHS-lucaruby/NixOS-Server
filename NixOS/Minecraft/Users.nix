{ lib, config, ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    users.users.svcminecraft = {
      isNormalUser = true;
    };

    users.groups.minecraft.members = [ "usrmgmt01" "svcminecraft" ];
  };  
}