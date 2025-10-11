{
  description = "Nixos Server config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    authentik-nix = {
      url = "github:nix-community/authentik-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = { 
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mysecrets = {
      url = "git+ssh://git@github.com/VGHS-lucaruby/NixOS-Server-Secrets.git?shallow=1";
      flake = false;
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    simple-nixos-mailserver= {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-generators, nixos-hardware, sops-nix, mysecrets, ... } @inputs:
  let
      arch = "x86_64-linux";

      nodes = [
      # List hostnames here for configuration
        "DATHOAI01"
        "DATHOAUTHENTIK01"
        "DATHOGRAFANA01"
        "DATHOJELLY01"
        "DATHOMAIL01"
        "DATHOMINECRAFT01"
        "DATHOPOSTGRES01"
        "DATHOLOG01"
        "DATHOTANDOOR01"
        "DATHOUNIFI01"
      ];
      
      generator = (
        # Function that templates out a value for the `packages` attrset.
        # Used for defining the NixOS generator for a given node.
        # docs: https://github.com/nix-community/nixos-generators/blob/master/README.md
        nodename:
          nixos-generators.nixosGenerate {
            system = arch;
            customFormats = { "proxmox-custom" = ./Formats/Proxmox-Custom.nix; };
            format = "proxmox-custom";
            modules = [
              ./NixOS
              ./Nodes/${nodename}.nix
              sops-nix.nixosModules.sops
            ];
            specialArgs = {
              # additional arguments to pass to modules
              inherit inputs;
              self = self;
              pkgs-unstable = nixpkgs-unstable.legacyPackages.${arch};
              allNodes = nodes;
              nodeHostName = nodename;
              nodeSecrets = "${mysecrets}/Nodes";
              primaryDomain = "datumine.co.uk";
            };
          }
      );
      configuration = (
        # Function that templates out a value for the `nixosConfigurations` attrset.
        # Used for bundling a nixos configuration for the node to be used for autoUpgrades after deployment.
        nodename:
          nixpkgs.lib.nixosSystem {
            system = arch;
            modules = [
              ./NixOS
              ./Nodes/${nodename}.nix
              sops-nix.nixosModules.sops
            ];
            specialArgs = {
              # additional arguments to pass to modules
              inherit inputs;
              self = self;
              pkgs-unstable = nixpkgs-unstable.legacyPackages.${arch};
              allNodes = nodes;
              nodeHostName = nodename;
              nodeSecrets = "${mysecrets}/Nodes";
              primaryDomain = "datumine.co.uk";
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