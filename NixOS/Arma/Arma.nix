{config, pkgs, lib, nodeHostName, ...}:

let
	steam-app = "233780";
in {
    
    modSteamDownloader.enable = true;
	
    users.users.arma = {
		isSystemUser = true;
		home = "/user/armaserver";
		createHome = true;
		homeMode = "750";
		group = "arma";
	};

	users.groups.arma = {};

	systemd.services.ArmaServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}.service" ];
		after = [ "SteamDownloader@${steam-app}.service" ];

		serviceConfig = {
			ExecStart = lib.escapeShellArgs [
				"/srv/steam-app-${steam-app}/arma3server_x64"
                "-name=${nodeHostName}"
				
			];
			Nice = "-5";
			PrivateTmp = true;
			Restart = "always";
			User = "arma";
			WorkingDirectory = "~";
		};
		# environment = {
		# 	# linux64 directory is required by Valheim.
		# 	LD_LIBRARY_PATH = "/var/lib/steam-app-${steam-app}/linux64:${pkgs.glibc}/lib";
		# 	SteamAppId = "892970";
		# };
	};
}