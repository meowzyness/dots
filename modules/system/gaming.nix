{ pkgs, ... }:
{
	programs.steam = {
		enable = true;
		remotePlay.openFirewall = true;
		dedicatedServer.openFirewall = true;
		localNetworkGameTransfers.openFirewall = true;
		gamescopeSession.enable = true;
	};

	programs.gamemode = {
		enable = true;
		settings = {
			general = {
				renice = 10;
			};
			custom = {
				start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations Activated'";
				end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations Deactivated'";
			};
		};
	};

	programs.gamescope = {
		enable = true;
		capSysNice = false;
	};

	environment.systemPackages = with pkgs; [
		protonup-qt
		lutris
		bottles
		mangohud
		dualsensectl
	];
}
