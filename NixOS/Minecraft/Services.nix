{ lib, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rcon
  ];

  systemd.services.minecraft = {
    description = "Minecraft Server";
    serviceConfig = {
      User = "svcminecraft";
      WorkingDirectory = "/opt/minecraft";

      ExecStart = ''sh -c "java @user_jvm_args.txt -jar server.jar nogui"'';
      ExecStop = ''
        sh -c "rcon -H 127.0.0.1 -p 25575 -P $(cat ${config.sops.secrets."Passwords/rcon".path}) -m 'say Server is shutting down 2 minute'" &&
        sleep 100 &&
        sh -c "rcon -H 127.0.0.1 -p 25575 -P $(cat ${config.sops.secrets."Passwords/rcon".path}) -m 'say Server is shutting down 20 seconds'" &&
        sleep 20 &&
        sh -c "rcon -H 127.0.0.1 -p 25575 -P $(cat ${config.sops.secrets."Passwords/rcon".path}) -m 'say Server is shutting down'" &&
        sleep 1 &&
        sh -c "rcon -H 127.0.0.1 -p 25575 -P $(cat ${config.sops.secrets."Passwords/rcon".path}) -m 'stop'"
      '';

      Restart = "always";
      RestartSec = "30";

      StandardInput = "null";
    };
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
  };

  systemd.timers."minecraft-timer" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "6h";
      Unit = "minecraft.service";
    };
  };

  systemd.services.minecraft.enable = true ;
}