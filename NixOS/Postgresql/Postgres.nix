{ pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "Authentik" ];
    enableTCPIP = true;
    port = 5432;
    package = pkgs.postgresql_15;
    authentication = pkgs.lib.mkOverride 10 ''
      # Generated file do not edit
      # Type   database   DBuser   origin-address   auth-method
      local    all        all                       scram-sha-256
      host     all        all      10.0.0.0/16      scram-sha-256
    '';
    ensureUsers = [
      {
        name = "Authentik";
        passwordFile = ; # Waiting to see what happens with PR#326306
        # Todo Rest of perms
      }
    ];

    # Todo Backups

    # initialScript = pkgs.writeText "backend-initScript" ''
    #   CREATE ROLE nixcloud WITH LOGIN PASSWORD 'nixcloud' CREATEDB;
    #   CREATE DATABASE nixcloud;
    #   GRANT ALL PRIVILEGES ON DATABASE nixcloud TO nixcloud;
    # '';
  };
}