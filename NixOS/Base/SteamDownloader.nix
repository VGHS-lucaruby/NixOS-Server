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
	  	home = "/home/steam";
	  	createHome = true;
	  };

	  users.groups.steam = {};

		systemd.tmpfiles.rules = [ "d /var/lib/SteamDownloader 0770 steam steam - -" ];

	  systemd.services."SteamDownloader@" = {
	  	unitConfig = {
	  		StopWhenUnneeded = true;
	  	};
	  	serviceConfig = {
	  		Type = "oneshot";
	  		ExecStart = "${pkgs.writeShellScript "SteamDownloader"
				''
	  			app=''${1:?App ID missing}
					
					echo $app

	  			cmds="
	  				+force_install_dir /var/lib/SteamDownloader/$app
	  				+login "$(cat ${config.sops.secrets."SteamDownloader/user".path})" "$(cat ${config.sops.secrets."SteamDownloader/password".path})"
	  				+app_update $app validate
						+quit
	  			"

	  			${pkgs.steamcmd}/bin/steamcmd $cmds
	  		''} %i";
	  		PrivateTmp = true;
	  		Restart = "on-failure";
	  		TimeoutStartSec = 3600; # Allow time for updates.
	  		User = "steam";
	  		WorkingDirectory = "/var/lib/SteamDownloader";
	  	};
	  };
  };
}