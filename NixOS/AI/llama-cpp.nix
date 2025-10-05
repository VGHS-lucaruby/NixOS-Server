{ config, pkgs, ... }:

let
  model = pkgs.fetchurl {
    name = "llama-3.1-8b-instruct-q4_k_m.gguf";
    url = "https://huggingface.co/modularai/Llama-3.1-8B-Instruct-GGUF/resolve/main/llama-3.1-8b-instruct-q4_k_m.gguf?download=true";
    sha256 = "sha256-ewZPWEK/lTLJFFbe2iiKG2cjl6VPpymqZllShjAzVXw=";
  };
in {
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { vulkanSupport = true; };
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    extraFlags = [ 
      "-ngl 99"
      "--jinja"
    ];
  };

  systemd.services.llama-cpp = {
    environment.XDG_CACHE_HOME = "/var/cache/llama.cpp";
    serviceConfig.CacheDirectory = "llama.cpp";
  };

  # Set VRAM to 20GB
  boot.kernelParams = [ 
    "amdttm.pages_limit=5120000" 
    "amdttm.pagpage_pool_size=5120000"
  ];
}