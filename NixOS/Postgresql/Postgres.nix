{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/postgresql/data 0700 postgres postgres - -" ];

  sops.secrets = {
    "Postgres/admin" = { owner = "postgres"; };
    "Postgres/authentik" = { owner = "postgres"; };
    "Postgres/tandoor" = { owner = "postgres"; };
    "Postgres/grafana" = { owner = "postgres"; };
    "Postgres/firefly" = { owner = "postgres"; };
    "Postgres/hedgedoc" = { owner = "postgres"; };
  };

  # Use lower case names for DB and users lol
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ "authentik" "tandoor" "grafana" "firefly" "hedgedoc" ];
      enableTCPIP = true;
      package = pkgs.postgresql_15;
      dataDir = "/var/lib/postgresql/data";
      settings = {
        port = 5432;
      };
      authentication = pkgs.lib.mkOverride 10 ''
        # Generated file do not edit
        # Type   database   DBuser   origin-address   auth-method
        local    all        all                       trust
        host     all        all      10.0.0.0/16      scram-sha-256
      '';
      ensureUsers = [
        {
          name = "admin";
          # passwordFile = ; # Waiting to see what happens with PR#326306
          ensureClauses = {
            superuser = true;
          };
        }
      ] ++ (map ( dataBase: { name = dataBase; ensureDBOwnership = true; }) config.services.postgresql.ensureDatabases);
      
      # Set Passwords
      # Replace once PR#326306 is upstreamed
      initialScript = pkgs.writeText "init-sql-script" ''
        DO $$
        ${toString (map ( dataBase: "DECLARE pwd${dataBase} TEXT;\n") config.services.postgresql.ensureDatabases)}
        BEGIN
          pwdAdmin := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/admin".path}'), E'\n', '''));
          ${toString (map ( dataBase: "pwd${dataBase} := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/${dataBase}".path}'), E'\\n', ''));\n") config.services.postgresql.ensureDatabases)}

          EXECUTE format('ALTER USER admin PASSWORD '''%s''';', pwdAdmin);
          ${toString (map ( dataBase: "EXECUTE format('ALTER USER ${dataBase} PASSWORD ''%s'';', pwd${dataBase});\n") config.services.postgresql.ensureDatabases)}
        END $$;
      '';
    };

    postgresqlBackup ={
      enable = true;
      compression = "zstd";
      compressionLevel = 11;
      location = "/var/lib/postgresqlBackups";
      startAt = "18:00";
    };
  };
}