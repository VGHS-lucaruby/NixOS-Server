{config, pkgs, lib, ...}: 

{
  config = lib.mkIf config.modSteamDownloader.enable {

		nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    	"steamcmd"
			"steam-run"
			"steam-original"
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
	  			app=''${1:?App ID missing}

	  			cmds="
	  				+force_install_dir /var/lib/SteamDownloader/$app
	  				+login "$(cat ${config.sops.secrets."SteamDownloader/user".path})" "$(cat ${config.sops.secrets."SteamDownloader/password".path})"
	  				+app_update $app validate
						+quit
	  			"

	  			${pkgs.steamcmd}/bin/steamcmd $cmds
					
					for f in $dir/*; do
						if ! [[ -f $f && -x $f ]]; then
							continue
						fi

						# Update the interpreter to the path on NixOS.
						${pkgs.patchelf}/bin/patchelf --set-interpreter ${pkgs.glibc}/lib/ld-linux-x86-64.so.2 $f || true
					done

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