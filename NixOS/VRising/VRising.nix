{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
	serverargs = pkgs.writeText "ServerArgs" ''
		-serverName "${nodeHostName}" 
		-saveName "world" 
		-password $(cat ${config.sops.secrets."VRising/password".path})
		-description "Ah, A Server, Yes"
		-maxUsers "10"
		-maxAdmins "4"
		-saveCount "10"
		-preset "StandardPvP",
    	-ListOnSteam "true"
		-disableLanMode
	'';
	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
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