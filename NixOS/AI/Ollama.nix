{ config, pkgs, pkgs-unstable, ... }:

{
  services = {
    ollama = {
      enable = true;
      acceleration = "rocm";
      rocmOverrideGfx = "11.5.1";
      host = "0.0.0.0";
      openFirewall = true;
      package = pkgs-unstable.ollama;
      # environmentVariables = {
      #   OLLAMA_DEBUG = "1";
      # };
      loadModels = [ 
        "gpt-oss"
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
        model = "medium";
        uri = "tcp://0.0.0.0:10300";
      };
    };
  };
}