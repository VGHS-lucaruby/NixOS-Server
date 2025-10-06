{ config, pkgs, pkgs-unstable, ... }:

let
  model = pkgs.fetchurl {
    name = "gpt-oss-20b-mxfp4.gguf";
    url = "https://huggingface.co/ggml-org/gpt-oss-20b-GGUF/resolve/main/gpt-oss-20b-mxfp4.gguf?download=true";
    sha256 = "sha256-vjemNqyg/BquDTIyX4L2tNIUlfBoI7X7wYmK4DA+mTU=";
  };
in {
  services.llama-cpp = {
    enable = true;
    package = pkgs-unstable.llama-cpp.override { vulkanSupport = true; };
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    extraFlags = [ 
      "-ngl" "99"
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