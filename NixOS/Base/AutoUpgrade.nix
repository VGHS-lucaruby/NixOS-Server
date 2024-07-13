{ lib, config, nodeHostName, ... }:

{
  system.autoUpgrade = {
    enable = true;
    dates = "Sat *-*-* 03:00 Europe/London";
    # randomizedDelaySec = "2hr";
    allowReboot = true;
    flake = "github:VGHS-lucaruby/NixOS-Server#${nodeHostName}";  
    flags = [
      "-L" # print build logs
      "--refresh" # update the repository
    ];
  };
}