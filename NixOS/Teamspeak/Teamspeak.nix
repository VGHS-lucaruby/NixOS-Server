{ config, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  services.teamspeak3 = {
    enable = true;
    openFirewall = true;
  };
}

