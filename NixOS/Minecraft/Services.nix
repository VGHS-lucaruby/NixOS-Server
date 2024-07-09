{ lib, config, ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    systemd.services.minecraft = {
      description = "Minecraft Server";
      serviceConfig = {
        User="svcminecraft";
        WorkingDirectory="/opt/minecraft";

        ExecStart="java -XX:+UseG1GC -Xmx12G -jar server.jar --nojline --noconsole";

        Restart="always";
        RestartSec="30";

        StandardInput="null";
      };
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    systemd.services.minecraft.enable = builtins.pathExists "/opt/minecraft" ;
  };
}