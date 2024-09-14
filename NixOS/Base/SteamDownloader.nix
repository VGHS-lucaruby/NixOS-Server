{config, pkgs, lib, ...}: 

{
  config = lib.mkIf config.modSteamDownloader.enable {

		nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    	"steamcmd"
			"steam-run"
			"steam-original"
  	];

    sops.secrets = {
      "SteamDownloader/user" = { owner = "steam"; };
      "SteamDownloader/password" = { owner = "steam"; };
    };

	  users.users.steam = {
	  	isSystemUser = true;
	  	group = "steam";
	  	home = "/srv/user/steam";
	  	createHome = true;
	  };

	  users.groups.steam = {};

		systemd.tmpfiles.rules = [ "d /srv/SteamDownloader 0770 steam steam - -" ];

	  systemd.services."SteamDownloader@" = {
	  	unitConfig = {
	  		StopWhenUnneeded = true;
	  	};
	  	serviceConfig = {
	  		Type = "oneshot";
	  		ExecStart = "${pkgs.writeScript "SteamDownloader"
				''
	  			app=''${1:?App ID missing}

	  			cmds="
	  				+force_install_dir /srv/SteamDownloader/$app
	  				+login "$(cat ${config.sops.secrets."SteamDownloader/user".path})" "$(cat ${config.sops.secrets."SteamDownloader/password".path})"
	  				+app_update $app validate
						+quit
	  			"

	  			${pkgs.steamcmd}/bin/steamcmd $cmds
	  		''} %i";
	  		PrivateTmp = true;
	  		Restart = "on-failure";
	  		StateDirectory = "steam-app-%i";
	  		TimeoutStartSec = 3600; # Allow time for updates.
	  		User = "steam";
	  		WorkingDirectory = "~";
	  	};
	  };
  };
}