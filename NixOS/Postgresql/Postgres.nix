{ config, pkgs, ... }:

{
  systemd.tmpfiles.rules = [ "d /var/lib/postgresql/data 0700 postgres postgres - -" ];

  # Use lower case names for DB and users lol
  services = {
    postgresql = {
      enable = true;
      ensureDatabases = [ "authentik" "tandoor" "grafana" "firefly" ];
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
        {
          name = "authentik";
          # passwordFile = ; # Waiting to see what happens with PR#326306
          ensureDBOwnership = true;
        }
        {
          name = "tandoor";
          # passwordFile = ; # Waiting to see what happens with PR#326306
          ensureDBOwnership = true;
        }
        {
          name = "grafana";
          # passwordFile = ; # Waiting to see what happens with PR#326306
          ensureDBOwnership = true;
        }
        {
          name = "firefly";
          # passwordFile = ; # Waiting to see what happens with PR#326306
          ensureDBOwnership = true;
        }
      ];
    };

    postgresqlBackup ={
      enable = true;
      compression = "zstd";
      compressionLevel = 11;
      location = "/var/lib/postgresqlBackups";
      startAt = "18:00";
    };
  };

  # Set Passwords
  # Replace once PR#326306 is upstreamed
  sops.secrets = {
    "Postgres/admin" = { owner = "postgres"; };
    "Postgres/authentik" = { owner = "postgres"; };
    "Postgres/tandoor" = { owner = "postgres"; };
    "Postgres/grafana" = { owner = "postgres"; };
    "Postgres/firefly" = { owner = "postgres"; };
  };

  systemd.services.postgresql.postStart = ''
    $PSQL -tA <<'EOF'
      DO $$
      DECLARE pwdAdmin TEXT;
      DECLARE pwdAuthentik TEXT;
      DECLARE pwdTandoor TEXT;
      DECLARE pwdGrafana TEXT;
      DECLARE pwdFireFly TEXT;
      BEGIN
        pwdAdmin := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/admin".path}'), E'\n', '''));
        pwdAuthentik := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/authentik".path}'), E'\n', '''));
        pwdTandoor := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/tandoor".path}'), E'\n', '''));
        pwdGrafana := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/grafana".path}'), E'\n', '''));
        pwdFireFly := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/firefly".path}'), E'\n', '''));
        EXECUTE format('ALTER USER admin PASSWORD '''%s''';', pwdAdmin);
        EXECUTE format('ALTER USER authentik PASSWORD '''%s''';', pwdAuthentik);
        EXECUTE format('ALTER USER tandoor PASSWORD '''%s''';', pwdTandoor);
        EXECUTE format('ALTER USER grafana PASSWORD '''%s''';', pwdGrafana);
        EXECUTE format('ALTER USER firefly PASSWORD '''%s''';', pwdFireFly);
      END $$;
    EOF
  '';
}