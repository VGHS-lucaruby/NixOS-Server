{ lib, config, nodeHostName, ... }:

{
  system.autoUpgrade = {
    enable = true;
    flake = "github:VGHS-lucaruby/NixOS-Server#${nodeHostName}";  
    dates = "Sat *-*-* 03:00 Europe/London";
    # randomizedDelaySec = "2hr";
    allowReboot = true;
    rebootWindow = {
      lower = "03:00";
      upper = "05:00";
    };
    flags = [
      "-L" # print build logs
      "--refresh" # update the repository
    ];
  };
}