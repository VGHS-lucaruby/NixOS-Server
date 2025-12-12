{ config, lib, nodeHostName, ... }:

{
  imports = [
    ./Base
  ];

  options = {
    modGenerator.enable = lib.mkEnableOption "Flag When Creating Image Using Nix-Generator";
  };

  config = {
    # Increase ulimit -n to resolve build issues.
    security.pam.loginLimits = [{
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "8192";
    }];
    systemd.settings.Manager = {
      DefaultLimitNOFILE = 8192;
    };
    
    networking.hostName = nodeHostName;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "24.05";
  };
}