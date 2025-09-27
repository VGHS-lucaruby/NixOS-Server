{ config, pkgs, ... }:

let
  model = pkgs.fetchurl {
    name = "DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf";
    url = "https://huggingface.co/bartowski/Meta-Llama-3.1-8B-Instruct-GGUF/resolve/main/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf?download=true";
    sha256 = "sha256-ewZPWEK/lTLJFFbe2iiKG2cjl6VPpymqZllShjAzVXw=";
  };

in {
  services.llama-cpp = {
    enable = true;
    package = pkgs.llama-cpp.override { vulkanSupport = true; };
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    extraFlags = [ "-ngl" "100"];
  };

  systemd.services.llama-cpp = {
    environment.XDG_CACHE_HOME = "/var/cache/llama.cpp";
    serviceConfig.CacheDirectory = "llama.cpp";
  };
}