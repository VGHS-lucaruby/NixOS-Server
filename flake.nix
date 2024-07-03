{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, home-manager, ... } @inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.DATHOTEST02 = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [ 
        ./Hosts/DATHOTEST02.nix
      ];
    };
  };
}