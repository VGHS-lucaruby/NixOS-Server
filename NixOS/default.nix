{ config, lib, nodeHostName, ... }:

{
  imports = [
    ./Base
  ];

  options = {
    modGenerator.enable = lib.mkEnableOption "Flag When Creating Image Using Nix-Generator";
  };

  config = {
    networking.hostName = nodeHostName;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    system.stateVersion = "24.05";
  };
}