{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
	serverargs = pkgs.writeText "ServerArgs" ''
		-serverName ${nodeHostName}
		-persistentDataPath /var/lib/SteamDownloader/${steam-app}/saves
		-logFile /var/lib/SteamDownloader/${steam-app}/logs
		-saveName world
		-maxUsers 10
		-maxAdmins 4
		-saveCount 10
		-preset StandardPvP
		-ListOnSteam true
		-ListOnEOS true
	'';
	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
		WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64 ${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs})) -password $(cat ${config.sops.secrets."VRising/password".path})
	'';

	# serverMods = pkgs.fetchzip {
	# 	url = "https://drive.google.com/uc?export=download&id=1h3gVGW1qHbiYWQNO-iwHscwGLitdXRhT";
  	# 	hash = "";
	# };

	serverMods = fetchTarball {
		url = "https://drive.google.com/uc?export=download&id=1h3gVGW1qHbiYWQNO-iwHscwGLitdXRhT";
  		sha256 = "sha256:0xs1y3z8z7hj097j6mi8kjdc0nqgbymqdij7a23bac6bd6pd0hna";
	};

in {
	
	sops.secrets = {
		"VRising/password" = { owner = "steam"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.VRisingServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}-windows.service" ];
		after = [ "SteamDownloader@${steam-app}-windows.service" ];

		preStart = ''	
			ln -sf ${serverMods}/* ./
		'';

		serviceConfig = {
			ExecStart = pkgs.writeShellScript "InitVRisingServer" ''
				${pkgs.xvfb-run}/bin/xvfb-run ${startServer}
			'';
			Restart = "always";
			User = "steam";
			WorkingDirectory = "/var/lib/SteamDownloader/${steam-app}";
		};
	};
}