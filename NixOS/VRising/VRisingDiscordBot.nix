{ config, builtins, pkgs, lib, nodeHostName, ... }:

let
	botJar = pkgs.fetchurl {
		url = "https://github.com/DarkAtra/v-rising-discord-bot/releases/download/v2.12.3/v-rising-discord-bot-2.12.3.jar";
  		sha256 = "sha256-pkiLG2uTShpXcZTCEEKiUtU6Q9aJ+R+D0Qyr2sqjkK4=";
	};

in {
	
	users = { 
		users.vrdiscbot = {
	  		isSystemUser = true;
	  		group = "vrdiscbot";
	  		home = "/home/vrdiscbot";
	  		createHome = true;
	  	};
		groups.vrdiscbot = {};
	};

	systemd.tmpfiles.rules = [ "d /var/lib/VRisingDiscordBot 0770 vrdiscbot vrdiscbot - -" ];

	sops.secrets = {
		"DiscordBot/password" = { owner = "vrdiscbot"; };
		"DiscordBot/token" = { owner = "vrdiscbot"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.VRisingDiscordBot = {
		wantedBy = [ "multi-user.target" ];

		preStart = ''
			echo "bot:
  discord-bot-token: $(cat ${config.sops.secrets."DiscordBot/token".path})
  database-password: $(cat ${config.sops.secrets."DiscordBot/password".path})" > application.yml
		'';

		serviceConfig = {
			ExecStart = pkgs.writeShellScript "InitVRisingDiscordBot" ''
				${pkgs.zulu}/bin/java -jar ${botJar}
			'';
			Restart = "always";
			User = "vrdiscbot";
			WorkingDirectory = "/var/lib/VRisingDiscordBot";
		};
	};
}