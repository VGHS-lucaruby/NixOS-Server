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
      variables = {
        TMOUT=900
      };
      shellAliases = {
        upd = "sudo nixos-rebuild switch -L --refresh --flake github:VGHS-lucaruby/NixOS-Server";
        updb = "sudo nixos-rebuild boot -L --refresh --flake github:VGHS-lucaruby/NixOS-Server";
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