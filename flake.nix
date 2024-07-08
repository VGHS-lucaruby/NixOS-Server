{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... } @inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.DATHOMINECRAFT01 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [ 
        ./Hosts/DATHOMINECRAFT01/configuration.nix
      ];
    };
  };
}