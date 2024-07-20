{ lib, config, ... }:

{
  options = {
    modPostgres.enable = lib.mkEnableOption "Enables Postgresql Server Config";
  };

  imports = [

  ];
}