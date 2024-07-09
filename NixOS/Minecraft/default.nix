{ lib, config, ... }:

{
  options = {
    modMinecraft.enable = lib.mkEnableOption "Enables Minecraft Server Setup";
  };

  config = lib.mkIf config.modMinecraft.enable {
    imports = [
      ./Firewall.nix
      ./Java.nix
      ./Service.nix
      ./Users.nix
    ];
  };
}