{ config, lib, ... }:

{
  config = lib.mkIf config.modGraphics.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}