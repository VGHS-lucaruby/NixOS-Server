{
  description = "Nixos Server config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
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
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, nixos-hardware, sops-nix, mysecrets, ... } @inputs:
  let
      nodes = [
      # List hostnames here for configuration
        "DATHOARMA01"
        "DATHOAUTHENTIK01"
        "DATHOGRAFANA01"
        "DATHOMAIL01"
        "DATHOMINECRAFT01"
        "DATHOPOSTGRES01"
        "DATHOPROMETH01"
        "DATHOTANDOOR01"
        "DATHOUNIFI01"
        "DATHOVRISING01"
      ];
      
      generator = (
        # Function that templates out a value for the `packages` attrset.
        # Used for defining the NixOS generator for a given node.
        # docs: https://github.com/nix-community/nixos-generators/blob/master/README.md
        nodename:
          nixos-generators.nixosGenerate {
            system = "x86_64-linux";
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
            system = "x86_64-linux";
            modules = [
              ./NixOS
              ./Nodes/${nodename}.nix
              sops-nix.nixosModules.sops
            ];
            specialArgs = {
              # additional arguments to pass to modules
              inherit inputs;
              self = self;
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