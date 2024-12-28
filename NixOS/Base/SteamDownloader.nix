{config, pkgs, lib, ...}: 

{
  config = lib.mkIf config.modSteamDownloader.enable {

		nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    	"steamcmd"
		"steam-run"
		"steam-original"
		"steam-unwrapped"
  	];

    sops.secrets = {
      "SteamDownloader/user" = { owner = "steam"; };
      "SteamDownloader/password" = { owner = "steam"; };
    };

	  users.users.steam = {
	  	isSystemUser = true;
	  	group = "steam";
	  	home = "/home/steam";
	  	createHome = true;
	  };

	  users.groups.steam = {};

		systemd.tmpfiles.rules = [ "d /var/lib/SteamDownloader 0770 steam steam - -" ];

	  systemd.services."SteamDownloader@" = {
	  	unitConfig = {
	  		StopWhenUnneeded = true;
	  	};
	  	serviceConfig = {
	  		Type = "oneshot";
	  		ExecStart = "${pkgs.writeShellScript "SteamDownloader"
				''
	  		input=''${1}

				arr=(''${input//-/ })
				
				cmds="
					+@sSteamCmdForcePlatformType ''${arr[1]}
				    +force_install_dir /var/lib/SteamDownloader/''${arr[0]}
				    +login "$(cat ${config.sops.secrets."SteamDownloader/user".path})" "$(cat ${config.sops.secrets."SteamDownloader/password".path})"
				  "
				
				if [ ''${#arr[@]} = 2 ]; then
				  cmds+="
				    +app_update ''${arr[0]} validate
				    +quit
				    "
				    ${pkgs.steamcmd}/bin/steamcmd $cmds
				else
				  for i in ''${arr[@]:2}; do
				    opt=""
				    opt=$cmds"
				      +workshop_download_item ''${arr[0]} $i
				      +quit
				    "
				    ${pkgs.steamcmd}/bin/steamcmd $opt
				  done
				fi

	  		''} %i";
	  		PrivateTmp = true;
	  		Restart = "no";
	  		TimeoutStartSec = 3600; # Allow time for updates.
	  		User = "steam";
	  		WorkingDirectory = "/var/lib/SteamDownloader";
	  	};
	  };
  };
}