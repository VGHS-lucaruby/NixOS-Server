{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
	serverargs = pkgs.writeText "ServerArgs" ''
		-persistentDataPath ".\save-data" 
		-serverName "${nodeHostName}" 
		-saveName "world" 
		-logFile ".\logs\VRisingServer.log"
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
			ExecStart = pkgs.writeShellScript "StartVRisingServer" ''
				${pkgs.xvfb-run}/bin/xvfb-run -a --server-args="-screen 0 640x480x24:32 -nolisten tcp -nolisten unix"\
				SteamAppId=1604030 WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64\
				${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs}))
			'';
			Restart = "always";
			User = "steam";
			WorkingDirectory = "/var/lib/SteamDownloader/${steam-app}";
		};
	};
}