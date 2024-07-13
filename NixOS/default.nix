{ lib, nodeHostName, ... }:

{
  imports = [
    ./Base
    ./Minecraft
  ];

  networking.hostName = nodeHostName;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}