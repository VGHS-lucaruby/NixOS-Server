{ config, pkgs, lib, nodeHostName, ... }:

let
	steam-app = "1829350"; # VRising server tool
	serverargs = pkgs.writeText "ServerArgs" ''
		-serverName ${nodeHostName}
		-persistentDataPath /var/lib/SteamDownloader/${steam-app}
		-logFile /var/lib/SteamDownloader/${steam-app}/logs
		-saveName world
		-maxUsers 25
		-maxAdmins 4
		-saveCount 10
		-preset StandardPvP
		-listOnSteam true
		-listOnEOS true
		-gamePort 27015
		-queryPort 27016
	'';

	startServer = pkgs.writeShellScript "StartVRisingServer" '' 
		export SteamAppId=1604030
		WINEPREFIX=/var/lib/SteamDownloader/${steam-app} WINEARCH=win64 ${pkgs.wineWow64Packages.staging}/bin/wine /var/lib/SteamDownloader/${steam-app}/VRisingServer.exe $(echo $(cat ${serverargs})) -password $(cat ${config.sops.secrets."VRising/password".path})
	'';

	serverMods = fetchTarball {
		url = "https://drive.google.com/uc?export=download&id=18yw2jfF2g3UDz0dZ9Q1e0opJ48W44JW4";
		sha256 = "sha256:17p8k8ji7vgkcqxqrix78mb1pr2l2810xsb90cg8knmv0nzblq0v";
	};
	serverGameSetings = pkgs.writeText "ServerGameSettings.json" ''
{
  "GameDifficulty": "Normal",
  "GameModeType": "PvP",
  "CastleDamageMode": "Never",
  "SiegeWeaponHealth": "Normal",
  "PlayerDamageMode": "Always",
  "CastleHeartDamageMode": "CanBeDestroyedByPlayers",
  "PvPProtectionMode": "Medium",
  "DeathContainerPermission": "ClanMembers",
  "RelicSpawnType": "Unique",
  "SoulShard_DurabilityLossRate": 1.0,
  "CanLootEnemyContainers": true,
  "BloodBoundEquipment": true,
  "TeleportBoundItems": false,
  "BatBoundItems": false,
  "BatBoundShards": false,
  "AllowGlobalChat": true,
  "AllWaypointsUnlocked": false,
  "FreeCastleRaid": false,
  "FreeCastleClaim": false,
  "FreeCastleDestroy": false,
  "InactivityKillEnabled": false,
  "InactivityKillTimeMin": 3600,
  "InactivityKillTimeMax": 604800,
  "InactivityKillSafeTimeAddition": 172800,
  "InactivityKillTimerMaxItemLevel": 84,
  "StartingProgressionLevel": 0,
  "DisableDisconnectedDeadEnabled": true,
  "DisableDisconnectedDeadTimer": 60,
  "DisconnectedSunImmunityTime": 300.0,
  "InventoryStacksModifier": 1.0,
  "DropTableModifier_General": 1.0,
  "DropTableModifier_StygianShards": 1.0,
  "DropTableModifier_Missions": 1.0,
  "MaterialYieldModifier_Global": 1.0,
  "BloodEssenceYieldModifier": 1.0,
  "JournalVBloodSourceUnitMaxDistance": 25.0,
  "PvPVampireRespawnModifier": 1.0,
  "CastleMinimumDistanceInFloors": 2,
  "ClanSize": 20,
  "BloodDrainModifier": 1.0,
  "DurabilityDrainModifier": 1.0,
  "GarlicAreaStrengthModifier": 1.0,
  "HolyAreaStrengthModifier": 1.0,
  "SilverStrengthModifier": 1.0,
  "SunDamageModifier": 1.0,
  "CastleDecayRateModifier": 1.0,
  "CastleBloodEssenceDrainModifier": 1.0,
  "CastleSiegeTimer": 420.0,
  "CastleUnderAttackTimer": 60.0,
  "CastleRaidTimer": 600.0,
  "CastleRaidProtectionTime": 1800.0,
  "CastleExposedFreeClaimTimer": 300.0,
  "CastleRelocationCooldown": 10800.0,
  "CastleRelocationEnabled": true,
  "AnnounceSiegeWeaponSpawn": true,
  "ShowSiegeWeaponMapIcon": false,
  "BuildCostModifier": 1.0,
  "RecipeCostModifier": 1.0,
  "CraftRateModifier": 1.0,
  "ResearchCostModifier": 1.0,
  "RefinementCostModifier": 1.0,
  "RefinementRateModifier": 1.0,
  "ResearchTimeModifier": 1.0,
  "DismantleResourceModifier": 1.0,
  "ServantConvertRateModifier": 1.0,
  "RepairCostModifier": 1.0,
  "Death_DurabilityFactorLoss": 0.125,
  "Death_DurabilityLossFactorAsResources": 1.0,
  "StarterEquipmentId": 0,
  "StarterResourcesId": 0,
  "VBloodUnitSettings": [],
  "UnlockedAchievements": [],
  "UnlockedResearchs": [],
  "GameTimeModifiers": {
    "DayDurationInSeconds": 1080.0,
    "DayStartHour": 9,
    "DayStartMinute": 0,
    "DayEndHour": 17,
    "DayEndMinute": 0,
    "BloodMoonFrequency_Min": 10,
    "BloodMoonFrequency_Max": 18,
    "BloodMoonBuff": 0.2
  },
  "VampireStatModifiers": {
    "MaxHealthModifier": 1.0,
    "PhysicalPowerModifier": 1.0,
    "SpellPowerModifier": 1.0,
    "ResourcePowerModifier": 1.0,
    "SiegePowerModifier": 1.0,
    "DamageReceivedModifier": 1.0,
    "ReviveCancelDelay": 5.0
  },
  "UnitStatModifiers_Global": {
    "MaxHealthModifier": 1.0,
    "PowerModifier": 1.0,
    "LevelIncrease": 0
  },
  "UnitStatModifiers_VBlood": {
    "MaxHealthModifier": 1.0,
    "PowerModifier": 1.0,
    "LevelIncrease": 0
  },
  "EquipmentStatModifiers_Global": {
    "MaxHealthModifier": 1.0,
    "ResourceYieldModifier": 1.0,
    "PhysicalPowerModifier": 1.0,
    "SpellPowerModifier": 1.0,
    "SiegePowerModifier": 1.0,
    "MovementSpeedModifier": 1.0
  },
  "CastleStatModifiers_Global": {
    "TickPeriod": 5.0,
    "SafetyBoxLimit": 1,
    "EyeStructuresLimit": 1,
    "TombLimit": 12,
    "VerminNestLimit": 4,
    "PrisonCellLimit": 255,
    "HeartLimits": {
      "Level1": {
        "FloorLimit": 100,
        "ServantLimit": 5,
        "HeightLimit": 2
      },
      "Level2": {
        "FloorLimit": 250,
        "ServantLimit": 10,
        "HeightLimit": 4
      },
      "Level3": {
        "FloorLimit": 500,
        "ServantLimit": 15,
        "HeightLimit": 6
      },
      "Level4": {
        "FloorLimit": 750,
        "ServantLimit": 25,
        "HeightLimit": 8
      },
      "Level5": {
        "FloorLimit": 1000,
        "ServantLimit": 35,
        "HeightLimit": 10
      }
    },
    "CastleHeartLimitType": "Clan",
    "CastleLimit": 10,
    "NetherGateLimit": 1,
    "ThroneOfDarknessLimit": 1,
    "ArenaStationLimit": 5,
    "RoutingStationLimit": 10
  },
  "PlayerInteractionSettings": {
    "TimeZone": "Local",
    "VSPlayerWeekdayTime": {
      "StartHour": 20,
      "StartMinute": 0,
      "EndHour": 22,
      "EndMinute": 0
    },
    "VSPlayerWeekendTime": {
      "StartHour": 20,
      "StartMinute": 0,
      "EndHour": 22,
      "EndMinute": 0
    },
    "VSCastleWeekdayTime": {
      "StartHour": 20,
      "StartMinute": 0,
      "EndHour": 22,
      "EndMinute": 0
    },
    "VSCastleWeekendTime": {
      "StartHour": 20,
      "StartMinute": 0,
      "EndHour": 22,
      "EndMinute": 0
    }
  },
  "TraderModifiers": {
    "StockModifier": 1.0,
    "PriceModifier": 1.0,
    "RestockTimerModifier": 1.0
  },
  "WarEventGameSettings": {
    "Interval": 1,
    "MajorDuration": 1,
    "MinorDuration": 1,
    "WeekdayTime": {
      "StartHour": 0,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 59
    },
    "WeekendTime": {
      "StartHour": 0,
      "StartMinute": 0,
      "EndHour": 23,
      "EndMinute": 59
    },
    "ScalingPlayers1": {
      "PointsModifier": 1.0,
      "DropModifier": 1.0
    },
    "ScalingPlayers2": {
      "PointsModifier": 0.5,
      "DropModifier": 0.5
    },
    "ScalingPlayers3": {
      "PointsModifier": 0.25,
      "DropModifier": 0.25
    },
    "ScalingPlayers4": {
      "PointsModifier": 0.25,
      "DropModifier": 0.25
    }
  }
}'';

in {
	
	sops.secrets = {
		"VRising/password" = { owner = "steam"; };
	};

	modSteamDownloader.enable = true;

	systemd.services.VRisingServer = {
		wantedBy = [ "multi-user.target" ];

		# Install the game before launching.
		wants = [ "SteamDownloader@${steam-app}-windows.service" ];
		after = [ "SteamDownloader@${steam-app}-windows.service" ];

		preStart = ''	
			mkdir -p Settings
			mkdir -p Saves
			ln -sf ${serverGameSetings} ./Settings/ServerGameSettings.json
		'';

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