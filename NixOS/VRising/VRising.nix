{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
	serverargs = pkgs.writeText "ServerArgs" ''
		-persistentDataPath "/var/lib/SteamDownloader/${steam-app}/save-data" 
		-serverName "${nodeHostName}" 
		-saveName "world" 
		-logFile "/var/lib/SteamDownloader/${steam-app}/logs/VRisingServer.log"
		-password $(cat ${config.sops.secrets."VRising/password".path})
		-description "Ah, A Server, Yes"
		-maxUsers "10"
		-maxAdmins "4"
		-saveCount "10"
		-preset "StandardPvP",
    	-listOnEOS "true"
    	-ListOnSteam "true"
		-disableLanMode
	'';
	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
		set SteamAppId=1604030
		WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64 ${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs}))
	'';
in {
	
	sops.secrets = {
		"VRising/password" = { owner = "steam"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.VRisingServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}.service" ];
		after = [ "SteamDownloader@${steam-app}.service" ];

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