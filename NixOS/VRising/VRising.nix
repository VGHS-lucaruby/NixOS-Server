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
		-gamePort 27015
		-queryPort 27016
	'';

	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
		export SteamAppId=${steam-app}
		WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64 ${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs})) -password $(cat ${config.sops.secrets."VRising/password".path})
	'';

	serverMods = fetchTarball {
		url = "https://drive.google.com/uc?export=download&id=18yw2jfF2g3UDz0dZ9Q1e0opJ48W44JW4";
  		sha256 = "sha256:17p8k8ji7vgkcqxqrix78mb1pr2l2810xsb90cg8knmv0nzblq0v";
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

		# preStart = ''	
		# 	ln -sf ${serverMods}/* ./
		# '';

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