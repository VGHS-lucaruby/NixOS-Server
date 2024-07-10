{ lib, config, ... }:

{
 options = {
    modBIOS.enable = lib.mkEnableOption "Enables Grub BIOS";
  };

  config = lib.mkIf config.modBIOS.enable {
    boot.loader.grub = {
      enable = true;
      device = "/dev/disk/by-label/NIXBOOT"
    };
  };
}
