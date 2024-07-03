{config, ... }:

{
  imports =
  [
    ../NixOS/
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.hostName = "DATHOTEST02";
  system.stateVersion = "24.05";
}