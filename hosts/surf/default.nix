{ config, lib, pkgs, inputs, ... }:
{
	imports = [
		./hardware-configuration.nix
		inputs.nixos-hardware.nixosModules.microsoft-surface-common
		../../modules/system/surface.nix
		../../modules/system/laptop.nix

		../../modules/system/stylix.nix

		../../modules/system/boot.nix
		../../modules/system/locale.nix
		../../modules/system/console.nix

		../../modules/system/input.nix
		../../modules/system/network.nix
		../../modules/system/audio.nix
		../../modules/system/graphics.nix
		../../modules/system/bluetooth.nix

		../../modules/system/nix.nix
		../../modules/system/impermanence.nix
		../../modules/system/secrets.nix
		../../modules/system/remote-builders.nix

		../../modules/system/system-packages.nix
		../../modules/system/services.nix
		../../modules/system/desktop.nix
		../../modules/system/security.nix

		../../modules/system/docker.nix
		../../modules/system/gaming.nix

		../../users/meowzy
	];

	networking.hostName = "surf";

	boot = {
		kernelPackages = lib.mkForce (import "${inputs.nixos-hardware}/microsoft/surface/common" {
			inherit config lib;
			pkgs = inputs.nixpkgs-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system};
		}).config.boot.kernelPackages;

		kernelModules = [ "pinctrl_tigerlake" ];
		kernelParams = [
			"i915.enable_guc=3"
			"intel_pstate=no_turbo"
			"mem_sleep_default=s2idle"
			"resume_offset=8134656" # swapfile offset for hibernation
		];
		extraModprobeConfig = ''
			options snd-hda-codec-realtek model=alc274-dell1
		'';
		resumeDevice = "/dev/disk/by-uuid/2e7e60b8-60c8-492c-8897-dc51a4ddfe20";
	};

	# HiDPI screen. scale GTK/X11 apps for all users
	home-manager.sharedModules = [
		{
			home.sessionVariables = {
				GDK_SCALE = "2";
				XFT_DPI = "192";
			};
		}
	];

	swapDevices = [
		{
			device = "/var/lib/swapfile";
			size = 16*1024;
		}
	];

	system.stateVersion = "24.11";
}
