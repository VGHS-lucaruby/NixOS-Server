{ pkgs, ... }:

{
    forgeServers = pkgs.callPackage ./forgeServers/default.nix {};
}
