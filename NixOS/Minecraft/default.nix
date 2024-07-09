{ lib, config, ... }:

{
  options = {
    modMinecraft.enable = lib.mkEnableOption "Enables Minecraft Server Setup";
  };

  imports = [
    ./Firewall.nix
    ./Java.nix
    ./Services.nix
    ./Users.nix
  ];
}