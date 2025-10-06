{ lib, config, ... }:

{
  imports = [
    # ./llama-cpp.nix
    ./ollama.nix
  ];
}