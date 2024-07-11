{ lib, config, pkgs, ... }:

{
  imports = [
    ../../NixOS
    ./FileSystem.nix
  ];

  networking.interfaces.eth0.ipv4.addresses = [ 
    {
      address = "10.0.20.101";
      prefixLength = 24;
    } 
  ];

  modMinecraft.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "DATHOMINECRAFT01";
  system.stateVersion = "24.05";
}
