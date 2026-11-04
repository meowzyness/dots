{ ... }:
{
	imports = [
		./hardware-configuration.nix
		../../modules/system/nvidia.nix

		../../modules/system/stylix.nix

		../../modules/system/boot.nix
		../../modules/system/locale.nix
		../../modules/system/console.nix

		../../modules/system/network.nix
		../../modules/system/bluetooth.nix
		../../modules/system/audio.nix
		../../modules/system/graphics.nix
		../../modules/system/rgb.nix

		../../modules/system/nix.nix
		../../modules/system/impermanence.nix
		../../modules/system/secrets.nix

		../../modules/system/system-packages.nix
		../../modules/system/services.nix
		../../modules/system/desktop.nix
		../../modules/system/security.nix

		../../modules/system/gaming.nix

		../../users/meowzy
	];

	networking.hostName = "labrat";

	system.stateVersion = "26.11";
}
