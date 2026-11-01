{ lib, inputs, ... }:
{
	nix = {
		registry.nixpkgs.flake = inputs.nixpkgs;

		gc = {
			automatic = lib.mkDefault true;
			dates = lib.mkDefault "daily";
			options = lib.mkDefault "--delete-older-than 7d";
		};
		settings = {
			experimental-features = [ "nix-command" "flakes" ];
			auto-optimise-store = true;

			substituters = [
				"https://cache.nixos.org"
				"https://hyprland.cachix.org"
			];

			trusted-substituters = [
				"https://cache.nixos.org"
			];

			trusted-public-keys = [
				"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
				"hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
			];

			trusted-users = [
				"root"
				"tonic"
				"@wheel"
			];

			allowed-users = [
				"root"
				"@wheel"
			];

			http-connections = 50;
			max-substitution-jobs = 20;
			connect-timeout = 10;
			stalled-download-timeout = 100;
			download-attempts = 5;

		};
	};

	system.activationScripts.logRebuildTime = {
		text = ''
			LOG_FILE="/var/log/nixos-rebuild-log.json"
			TIMESTAMP=$(date "+%d/%m")
			GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

			echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
			chmod 644 "$LOG_FILE"
		'';
	};
}
