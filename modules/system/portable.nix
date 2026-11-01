{ pkgs, ... }:
{
	hardware.enableAllHardware = true;
	hardware.enableAllFirmware = true;
	hardware.cpu.intel.updateMicrocode = true;
	hardware.cpu.amd.updateMicrocode = true;
	boot.initrd.availableKernelModules = [ "usb_storage" "uas" ];

	boot.kernelPackages = pkgs.linuxPackages_latest;

	boot.loader.efi.canTouchEfiVariables = false;

	boot.initrd.systemd.emergencyAccess = true;

	zramSwap.enable = true;

	boot.tmp.useTmpfs = true;

	services.journald.settings.Journal.SystemMaxUse = "50M";

	boot.kernel.sysctl = {
		"vm.dirty_background_bytes" = 16 * 1024 * 1024;
		"vm.dirty_bytes" = 64 * 1024 * 1024;
	};
}
