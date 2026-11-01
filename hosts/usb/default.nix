{ inputs, ... }:
{
	imports = [
		inputs.disko.nixosModules.disko
		./disk.nix
		./test.nix

		../../modules/system/portable.nix
		../../modules/system/laptop.nix

		../../modules/system/boot.nix

		../../modules/system/network.nix
		../../modules/system/audio.nix

		../../modules/system/impermanence.nix
		../../modules/system/secrets.nix
		../../modules/system/locale.nix
		../../modules/system/console.nix
		../../modules/system/nix.nix
		../../modules/system/system-packages.nix
		../../modules/system/input.nix
		../../modules/system/services.nix
		../../modules/system/desktop.nix
		../../modules/system/security.nix
		../../modules/system/recovery.nix

		../../users/meowzy
	];

	networking.hostName = "usb";

	boot.loader.timeout = 3;

	hardware.graphics.enable = true;

	# leave out home modules
	home-manager.users.meowzy.disabledModules = [
		../../modules/home/apps.nix  # heavy
	];

	# for GParted and other root guis
	security.polkit.extraConfig = ''
		polkit.addRule(function(action, subject) {
			if (subject.isInGroup("wheel")) return polkit.Result.YES;
		});
	'';

	dots.impermanence = {
		enable = true;
		rollback.device = "/dev/disk/by-partlabel/disk-usb-root";
	};

	system.stateVersion = "26.11";
}
