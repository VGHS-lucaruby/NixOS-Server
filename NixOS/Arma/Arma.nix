{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "233780"; # arma server tool
	steam-basegame = "107410"; # arma 3
	mods = "450814997-3020755032-1779063631-894678801-463939057"; # CBA_A3 // Antistasi Ultimate // Zeus Enhanced // Task Force Arrowhead // Ace
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
		wants = [ "SteamDownloader@${steam-app}.service" "SteamDownloader@${steam-basegame}-${mods}.service"];
		after = [ "SteamDownloader@${steam-app}.service" "SteamDownloader@${steam-basegame}-${mods}.service"];

		serviceConfig = {
			ExecStart = pkgs.writeShellScript "StartArmaServer" ''
				${pkgs.steam-run}/bin/steam-run "/var/lib/SteamDownloader/${steam-app}/arma3server_x64" "-name=${nodeHostName}"
			'';
			Restart = "no";
			User = "arma";
			WorkingDirectory = "/home/arma";
		};
	};
}