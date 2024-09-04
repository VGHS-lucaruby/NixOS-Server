{ ... }:

{
  services.restic.backups = {
    daily = {
      exclude = [
        "/srv/minecraft/*/backups"
      ];
      paths = [
        "/srv/minecraft/*"
      ];
    };
  };
}