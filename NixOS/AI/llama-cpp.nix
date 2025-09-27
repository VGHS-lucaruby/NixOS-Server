{ config, pkgs, ... }:

let
  model = pkgs.fetchurl {
    name = "DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf";
    url = "https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-7B-Q6_K_L.gguf?download=true";
    sha256 = "";
  };

in {
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { vulkanSupport = true; };
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    extraFlags = [ "-ngl" "100" "--jinja" "--chat-template-file" "models/templates/llama-cpp-deepseek-r1.jinja" ];
  };

  systemd.services.llama-cpp = {
    environment.XDG_CACHE_HOME = "/var/cache/llama.cpp";
    serviceConfig.CacheDirectory = "llama.cpp";
  };
}