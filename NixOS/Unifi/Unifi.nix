{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.unifi = {
    enable = true;
    openFirewall = true;
    unifiPackage = pkgs.unifi;
    mongodbPackage = pkgs.mongodb-ce;
    jrePackage = pkgs.jdk21_headless;
  };
}