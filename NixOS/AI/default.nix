{ lib, config, ... }:

{
  imports = [
    ./Firewall.nix
    # ./Llama-cpp.nix
    ./Ollama.nix
  ];
}