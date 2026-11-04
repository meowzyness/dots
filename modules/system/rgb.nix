{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		openrgb-with-all-plugins
	];

	services.hardware.openrgb = {
		enable = true;
		package = pkgs.openrgb-with-all-plugins;
	};


	systemd.services.set-rgb = {
		wantedBy = [ "multi-user.target" ];
		serviceConfig.Type = "oneshot";
		script = "${pkgs.openrgb}/bin/openrgb --noautoconnect --mode static --color FF8000";
	};
}