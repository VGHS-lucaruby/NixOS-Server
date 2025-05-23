{
  description = "Custom Packages";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = {
      forgeServers = nixpkgs.callPackage ./forgeServers/default.nix {};
    };
  };
}