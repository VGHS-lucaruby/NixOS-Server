{
  description = "Nixos Server config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, ... } @inputs:
  let
      nodes = [
      # List hostnames here for configuration
        "DATHOMINECRAFT01"
      ];
      
      generator = (
        # Function that templates out a value for the `packages` attrset.
        # Used for defining the NixOS generator for a given node.
        # docs: https://github.com/nix-community/nixos-generators/blob/master/README.md
        nodename:
          nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            customFormats = { "proxmox-custom" = ./NixOS/Formats/Proxmox-Custom.nix; };
            format = "proxmox-custom";
            modules = [
              ./NixOS
              ./Nodes/${nodename}.nix
            ];
            specialArgs = {
              # additional arguments to pass to modules
              self = self;
              nodeHostName = nodename;
            };
          }
      );
      configuration = (
        # Function that templates out a value for the `nixosConfigurations` attrset.
        # Used for bundling a nixos configuration for the node to be used for autoUpgrades after deployment.
        nodename:
          nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./NixOS
              ./Nodes/${nodename}.nix
            ];
            specialArgs = {
              # additional arguments to pass to modules
              self = self;
              nodeHostName = nodename;
            };
          }
      );
    in {

      # This attrset evaluates to: {"my-nix-machine" = nixos-generators.nixosGenerate {...}; ... }
      packages.x86_64-linux = builtins.listToAttrs (
        map
          ( nodename: { "name" = nodename; "value" = generator(nodename); } )
          ( nodes )  # List of nodes to generate images for
      );

      # This attrset evaluates to: {"my-nix-machine" = nixpkgs.lib.nixosSystem {...}; ... }
      nixosConfigurations = builtins.listToAttrs (
        map
          ( nodename: { "name" = nodename; "value" = configuration(nodename); } )
          ( nodes )  # List of nodes to generate NixOS Configurations for
      );
  };
}