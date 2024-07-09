{ ... }:

{
  config = lib.mkIf config.modMinecraft.enable {
    programs.java.enable = true;
  };
}