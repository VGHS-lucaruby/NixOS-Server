{ lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "teamspeak-server"
    ];
  services.teamspeak3 = {
    enable = true;

    openFirewall = true;
  };
}

