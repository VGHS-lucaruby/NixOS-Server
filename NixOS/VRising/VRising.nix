{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
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
				${pkgs.xvfb-run}/bin/xvfb-run
				${pkgs.wineWow64Packages.staging}/bin/wine ./VRisingServer.exe 
				-persistentDataPath ".\save-data" -serverName "${nodeHostName}" -saveName "world" -logFile ".\logs\VRisingServer.log"
				-gamePort 27015 -queryPort 27016
				-password $(cat ${config.sops.secrets."VRising/password".path})
			'';
			Restart = "always";
			User = "steam";
			WorkingDirectory = "/var/lib/SteamDownloader/${steam-app}";
			EnvironmentFile = pkgs.writeText "EnvArgs" ''
				SteamAppId=1604030
				WINEPREFIX=/var/lib/SteamDownloader/${steam-app}
				WINEARCH=win64
			'';
		};
	};
}