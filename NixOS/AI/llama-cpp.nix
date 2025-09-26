{ config, pkgs, ... }:

let
  model = pkgs.fetchurl {
    name = "DeepSeek-R1-Distill-Qwen-32B-Q4_K_M.gguf";
    url = "https://huggingface.co/unsloth/DeepSeek-R1-Distill-Qwen-1.5B-GGUF/resolve/main/DeepSeek-R1-Distill-Qwen-1.5B-UD-Q4_K_XL.gguf?download=true";
    sha256 = "sha256-iOYqgFzw6Jzd0sn+Gqk6TO9pzEo7L/G7RNw8FyQPXVc=";
  };

in {
  services.llama-cpp = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    model = model;
    # extraFlags = [ "--jinja "];
  };
}