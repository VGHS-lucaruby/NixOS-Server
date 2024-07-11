{
  description = "Nixos Server config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-gitops.url = "github:VGHS-lucaruby/nixos-gitops";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-gitops, nixos-generators, nixos-hardware, ... } @inputs:
  let
      nodes = [
        {
          name = "DATHOMINECRAFT01";
          system = "x86_64-linux";
          format = "proxmox";
          modules = [
            ./Nodes/DATHOMINECRAFT01.nix
          ];
          nixpkgs = nixpkgs;
        }
      ];
    in {

      # Setup x86_64 nixos-generator
      packages.x86_64-linux = builtins.listToAttrs (
        map
          ( node: { 
              "name" = node.name; 
              "value" = nixos-generators.nixosGenerate(nixos-gitops.buildNixOSGenerator(node));
            } 
          )
          ( builtins.filter(node: node.system == "x86_64-linux") nodes )  # List of nodes to generate images for
      );

      # Setup aarch64 nixos-generator
      packages.aarch64-linux = builtins.listToAttrs (
        map
          ( node: { 
              "name" = node.name; 
              "value" = nixos-generators.nixosGenerate(nixos-gitops.buildNixOSGenerator(node));
            } 
          )
          ( builtins.filter(node: node.system == "aarch64-linux") nodes )  # List of nodes to generate images for
      );


      # Setup actual NixOS config
      nixosConfigurations = builtins.listToAttrs (
        map
          ( node: { 
              "name" = node.name; 
              "value" = nixpkgs.lib.nixosSystem(nixos-gitops.buildNixOSConfig(node));
            } 
          )
          ( nodes )  # List of nodes to generate NixOS Configurations for
      );
  };
}