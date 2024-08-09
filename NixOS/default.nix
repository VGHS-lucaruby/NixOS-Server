{ lib, nodeHostName, ... }:

{
  imports = [
    ./Base
  ];

  networking.hostName = nodeHostName;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}