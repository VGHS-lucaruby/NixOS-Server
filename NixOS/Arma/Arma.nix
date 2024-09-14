{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "233780";	
in {
		modSteamDownloader.enable = true;

		users.users.arma = {
		isSystemUser = true;
		home = "/home/arma";
		createHome = true;
		homeMode = "750";
		group = "arma";
		extraGroups = [ "steam" ];
	};

	users.groups.arma = {};

	systemd.services.ArmaServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}.service" ];
		after = [ "SteamDownloader@${steam-app}.service" ];

		serviceConfig = {
			ExecStart = lib.escapeShellArgs [
				"/var/lib/SteamDownloader/${steam-app}/arma3server_x64"
				"-name=${nodeHostName}"
			];
			Nice = "-5";
			PrivateTmp = true;
			Restart = "always";
			User = "arma";
			WorkingDirectory = "/home/arma";
		};
	};
}