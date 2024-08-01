{ lib, config, pkgs, ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    systemd.services.minecraft = {
      description = "Minecraft Server";
      serviceConfig = {
        User="svcminecraft";
        WorkingDirectory="/opt/minecraft";

        ExecStart="sh -c java @user_jvm_args.txt -jar server.jar nogui";
        ExecStop="sh -c stop.sh";

        Restart="always";
        RestartSec="30";

        StandardInput="null";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.minecraft.enable = true ;
  };
}