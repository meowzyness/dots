{ lib, pkgs, ... }:
{
	boot = {
		kernelParams = [
			"boot.shell_on_fail"
			"loglevel=3" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3"
		];
		consoleLogLevel = lib.mkDefault 0;

		plymouth = {
			enable = false;
			themePackages = with pkgs; [
				(adi1090x-plymouth-themes.override {
					selected_themes = [ "loader_2" ];
				})
			];
			theme = "loader_2";
		};
		supportedFilesystems = [ "ntfs" ];

		# Bootloader
		loader = {
			timeout = lib.mkDefault 0;
			systemd-boot = {
				enable = true;
				consoleMode = "max";
			};
			grub.enable = false;
			efi.canTouchEfiVariables = lib.mkDefault true;
		};
	};
}
