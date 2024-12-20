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
	'';
	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
		WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64 ${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs})) -password $(cat ${config.sops.secrets."VRising/password".path})
	'';
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