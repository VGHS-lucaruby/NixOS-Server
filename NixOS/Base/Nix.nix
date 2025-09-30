{ ... }:

{
  nix = {
    optimise = {
      automatic = true;
      dates = [ "23:00" ];
    };
    
    gc = {
      automatic = true;
      dates = "Sun *-*-* 03:00 Europe/London";
      options = "--delete-older-than 7d";
    };
  };
}