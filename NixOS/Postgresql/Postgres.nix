{ config, pkgs, ... }:

{
  # Use lower case names for DB and users lol
  services.postgresql = {
    enable = true;
    ensureDatabases = [ "authentik" ];
    enableTCPIP = true;
    package = pkgs.postgresql_15;
    dataDir = "/var/lib/postgresql";
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
        ensureDBOwnership  = true;
      }
    ];
  };


  # Set Passwords
  # Replace once PR#326306 is upstreamed
  sops.secrets = {
    "Postgres/admin" = { owner = "postgres"; };
    "Postgres/authentik" = { owner = "postgres"; };
  };

  systemd.services.postgresql.postStart =
    let
      Admin = config.sops.secrets."Postgres/admin".path;
      Authentik = config.sops.secrets."Postgres/authentik".path;
    in
    ''
      $PSQL -tA <<'EOF'
        DO $$
        DECLARE pwdAdmin TEXT;
        DECLARE pwdAuthentik TEXT;
        BEGIN
          pwdAdmin := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/admin".path}'), E'\n', '''));
          pwdAuthentik := trim(both from replace(pg_read_file('${config.sops.secrets."Postgres/authentik".path}'), E'\n', '''));
          EXECUTE format('ALTER USER admin PASSWORD '''%s''';', pwdAdmin);
          EXECUTE format('ALTER USER authentik PASSWORD '''%s''';', pwdAuthentik);
        END $$;
      EOF
    '';
}