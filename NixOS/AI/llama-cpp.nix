{ config, pkgs, ... }:

let
  model = pkgs.fetchurl {
    name = "DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf";
    url = "https://huggingface.co/bartowski/DeepSeek-R1-Distill-Qwen-32B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf?download=true";
    sha256 = "sha256-vtmw9VH1uVv52liIpI8Ph8N61rclGcTL13X1SsC5/GI=";
  };

in {
  services.llama-cpp = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    # extraFlags = [];
  };
}