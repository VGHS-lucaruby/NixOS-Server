{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.unifi = {
    enable = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb;
  };
}

