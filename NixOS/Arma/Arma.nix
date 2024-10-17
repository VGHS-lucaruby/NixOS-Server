{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "233780"; # arma server tool
	steam-basegame = "107410"; # arma 3
	#mods = "450814997-3020755032-1779063631-894678801-463939057"; # CBA_A3 // Antistasi Ultimate // Zeus Enhanced // Task Force Arrowhead // Ace

	Armaconfig = ./Arma.cfg;
	ConfigFilename = "arma.cfg";

	ACE = pkgs.fetchzip {
	url = "https://github.com/acemod/ACE3/releases/download/v3.18.1/ace3_3.18.1.zip";
  	hash = "sha256-9ISBp4EWscbiJPtAfth6tiHtIFQ53rqTmDa4W5LwmIc=";
	};
	Antistasi = pkgs.fetchzip {
  	url = "https://github.com/SilenceIsFatto/A3-Antistasi-Ultimate/releases/download/v11.2.1/@A3U.zip";
  	hash = "sha256-9ISBp4EWscbiJPtAfth6tiHtIFQ53rqTmDa4W5LwmIc=";
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
  	url = "https://github.com/CBATeam/CBA_A3/releases/download/v3.18.1/CBA_A3_v3.18.1.zip";
  	hash = "sha256-9ISBp4EWscbiJPtAfth6tiHtIFQ53rqTmDa4W5LwmIc=";
	};
in {
	
	sops.secrets = {
		"Arma/passwordEnv" = { owner = "steam"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.ArmaServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}.service" ];
		after = [ "SteamDownloader@${steam-app}.service" ];

		preStart = ''
			mkdir @ace && ln -sf ${ACE}/* @ace
			mkdir @A3U && ln -sf ${Antistasi}/* @A3U
			mkdir @zen && ln -sf ${Zeus}/* @zen
			mkdir @task_force_radio && ln -sf ${Arrowhead}/* @task_force_radio
			mkdir @CBA_A3 && ln -sf ${CBA}/* @CBA_A3
			ln -sf ${ACE}/keys/* keys
			ln -sf ${Antistasi}/keys/* keys
			ln -sf ${Zeus}/keys/* keys
			ln -sf ${Arrowhead}/keys/* keys
			ln -sf ${CBA}/keys/* keys	
			cat ${config.sops.secrets."Arma/passwordEnv".path} > ${ConfigFilename} && cat ${Armaconfig} >> ${ConfigFilename}
		'';

		serviceConfig = {
			ExecStart = pkgs.writeShellScript "StartArmaServer" ''
				${pkgs.steam-run}/bin/steam-run ./arma3server_x64 -config=${ConfigFilename} -mod="@ace;@A3U;@zen;@task_force_radio;@CBA_A3"
			'';
			Restart = "no";
			User = "steam";
			WorkingDirectory = "/var/lib/SteamDownloader/${steam-app}";
		};
	};
}