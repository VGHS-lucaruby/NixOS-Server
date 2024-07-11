{ lib, config, pkgs, ... }:

{
  imports = [
    ../NixOS
  ];

  # Enable Modules
  modMinecraft.enable = true;

  # # Change IP!!
  # networking = {
  #     hostName = "${nodeHostName}";
  #     interfaces.eth0.ipv4.addresses = [ 
  #     {
  #       address = "10.0.20.101";
  #       prefixLength = 24;
  #     } 
  #   ];
  # };


  # system.autoUpgrade = {
  #   enable = true;
  #   randomizedDelaySec = "1hr";
  #   allowReboot = true;
  #   flake = "github:VGHS-lucaruby/NixOS-Server#${nodeHostName}";  
  #   flags = [
  #     "-L" # print build logs
  #     "--refresh" # update the repository
  #   ];
  # };

  fileSystems."/" = { 
    label = "nixos";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    label = "ESP";
  };

  # Can be left alone
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}
