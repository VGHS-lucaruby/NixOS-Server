{ ... }:

{
  services.restic.backups = {
    daily = {
      exclude = [
        "/srv/minecraft/*/backup"
      ];
      paths = [
        "/srv/minecraft/*"
      ];
    };
  };
}