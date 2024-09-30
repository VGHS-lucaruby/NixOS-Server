{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "233780"; # arma server tool
	steam-basegame = "107410"; # arma 3
	#mods = "450814997-3020755032-1779063631-894678801-463939057"; # CBA_A3 // Antistasi Ultimate // Zeus Enhanced // Task Force Arrowhead // Ace

	Armaconfig = ./Arma.cfg;

	ACE = builtins.fetchGit {
  		url = "https://github.com/acemod/ACE3.git";
  		ref = "refs/tag/v3.17.1";
	};
	Antistasi = builtins.fetchGit {
  		url = "https://github.com/SilenceIsFatto/A3-Antistasi-Ultimate";
  		ref = "refs/tag/v11.1.0";
	};
	Zeus = builtins.fetchGit {
  		url = "https://github.com/zen-mod/ZEN";
  		ref = "refs/tag/v1.15.1";
	};
	Arrowhead = builtins.fetchGit {
  		url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
  		ref = "refs/tag/0.9.12";
	};
	CBA = builtins.fetchGit {
  		url = "https://github.com/CBATeam/CBA_A3";
  		ref = "refs/tag/v3.17.1.240424";
	};
in {
	
	sops.secrets = {
		"Arma/password" = { owner = "arma"; };
		"Arma/passwordAdmin" = { owner = "arma"; };
		"Arma/serverCommandPassword" = { owner = "arma"; };
	};

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
			ExecStart = pkgs.writeShellScript "StartArmaServer" ''
				${pkgs.steam-run}/bin/steam-run "/var/lib/SteamDownloader/${steam-app}/arma3server_x64" "-conifg=${Armaconfig}" "-password=''${cat ${config.sops.secrets."Arma/password".path}}" "-passwordAdmin=''${cat ${config.sops.secrets."Arma/passwordAdmin".path}}" "-serverCommandPassword=''${cat ${config.sops.secrets."Arma/serverCommandPassword".path}}"
			'';
			Restart = "no";
			User = "arma";
			WorkingDirectory = "/home/arma";
		};
	};
}