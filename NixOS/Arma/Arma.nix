{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "233780"; # arma server tool
	steam-basegame = "107410"; # arma 3
	#mods = "450814997-3020755032-1779063631-894678801-463939057"; # CBA_A3 // Antistasi Ultimate // Zeus Enhanced // Task Force Arrowhead // Ace

	Armaconfig = ./Arma.cfg;

	ACE = pkgs.fetchzip {
		url = "https://github.com/acemod/ACE3/releases/download/v3.18.0/ace3_3.18.0.zip";
  	hash = "sha256-PFf0P0MISqhR+JlY/J/c6X0BRf05DrMpom0SqJt5Mr0=";
	};
	Antistasi = pkgs.fetchzip {
  	url = "https://github.com/SilenceIsFatto/A3-Antistasi-Ultimate/releases/download/v11.2.0/@A3U.zip";
  	hash = "sha256-MeGiDbn5rtj2XCRu2PVp5BEHVzsqKoYPoBKOWcFacIo=";
	};
	Zeus = pkgs.fetchzip {
  	url = "https://github.com/zen-mod/ZEN/releases/download/v1.15.1/zen_1.15.1.zip";
  	hash = "sha256-/jxtxuSq8MgFY7V12hEKL6nzA1MqfiWdtXy09OymrEI=";
	};
	Arrowhead = pkgs.fetchzip {
  	url = "https://github.com/michail-nikolaev/task-force-arma-3-radio/releases/download/0.9.12/0.9.12.zip";
  	hash = "sha256-QG0p6Wc1sAcS7ZWD1cF2R++6W8br1LVFvMahaFJJN/0=";
	};
	CBA = pkgs.fetchzip {
  	url = "https://github.com/CBATeam/CBA_A3/releases/download/v3.18.0.241008/CBA_A3_v3.18.0.zip";
  	hash = "sha256-ofSeDkOUkQT/3iz6NZAZ46z9UQS0psYiL1c5yimCZEk=";
	};
in {
	
	sops.secrets = {
		"Arma/password" = { owner = "steam"; };
		"Arma/passwordAdmin" = { owner = "steam"; };
		"Arma/serverCommandPassword" = { owner = "steam"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.ArmaServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}.service" ];
		after = [ "SteamDownloader@${steam-app}.service" ];

		serviceConfig = {
			ExecStart = pkgs.writeShellScript "StartArmaServer" ''
				${pkgs.steam-run}/bin/steam-run ./arma3server_x64 -conifg=${Armaconfig} \
				-password="$(cat ${config.sops.secrets."Arma/password".path})" -passwordAdmin="$(cat ${config.sops.secrets."Arma/passwordAdmin".path})" -serverCommandPassword="$(cat ${config.sops.secrets."Arma/serverCommandPassword".path})" \
				-mod="${ACE}/@ACE;${Antistasi}/@A3U;${Zeus}/@zen;${Arrowhead}/@task_force_radio;${CBA}/@CBA_A3"
			'';
			Restart = "no";
			User = "steam";
			WorkingDirectory = "/var/lib/SteamDownloader/${steam-app}";
		};
	};
}