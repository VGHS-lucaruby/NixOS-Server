{ config, lib, pkgs, pkgs-unstable, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "open-webui"
  ];

  #environment.systemPackages = [ pkgs.ollama-rocm ];

  services = {
    ollama = {
      enable = true;
      acceleration = "vulkan";
      # rocmOverrideGfx = "11.5.1";
      host = "0.0.0.0";
      openFirewall = true;
      package = pkgs-unstable.ollama-vulkan;
      # environmentVariables = {
      #   OLLAMA_DEBUG = "2";
      # };
      loadModels = [ 
        "qwen3-vl"
        "granite4"
      ];
    };
    
    open-webui = {
      enable = true;
      host = "0.0.0.0";
      openFirewall = true;
    };      

    wyoming = {
      piper.servers."PiperMain" = {
        enable = true;
        uri = "tcp://0.0.0.0:10200";
        voice = "en_GB-jenny_dioco-medium";
      };
    # openwakeword = {
    #   enable = true;
    #   customModelsDirectories = [ "/var/lib/openwakeword/models" ];
    #   preloadModels = [
    #     "ok_nabu"
    #   ];
    # };
      faster-whisper.servers."WhisperMain" = {
        enable = true;
        language = "auto";
        model = "medium-int8";
        uri = "tcp://0.0.0.0:10300";
      };
    };
  };
}