{ config, lib, sops, primaryDomain, ... }:

{
  sops.secrets = {
    "Passwords/root".neededForUsers = true;
  };
  
  users = {
    # Set root user password to value assigned in Sops secret file and disable mutability
    # Unless generating a system image using Nix-Generator, in which case set password to "temp" and allow mutabilily.
    mutableUsers = config.modGenerator.enable;
    users.root = {
      password = if config.modGenerator.enable then "temp" else null;
      hashedPasswordFile =  if config.modGenerator.enable then null else config.sops.secrets."Passwords/root".path;
    };
  };
}