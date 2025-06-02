{ pkgs, ... }:

{
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [ zsh ];
  programs = {
    zsh = {
      enable = true;
      autosuggestions.enable = true;
      syntaxHighlighting.enable = true;
      enableLsColors = true;
      shellInit = "fastfetch";
      histSize = 1000;
      shellAliases = {
        upd = "nixos-rebuild switch -L --refresh --flake github:VGHS-lucaruby/NixOS-Server";
        updb = "nixos-rebuild boot -L --refresh --flake github:VGHS-lucaruby/NixOS-Server";
      };
      ohMyZsh = {
        enable = true;
        theme = "gallois";
        plugins = [
          "git"
          "history"
        ];
      };
    };
  };
}