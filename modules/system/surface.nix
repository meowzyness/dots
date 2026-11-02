{ pkgs, ... }:
{
	services.iptsd = {
		enable = true;

		config = {
			Touchscreen = {
				DisableOnPalm = true;
				DisableOnStylus = true;
			};
		};
	};

	# microsoft-surface.surface-control.enable = true;
	# microsoft-surface.surface-dtx.enable = true;
	services.thermald.enable = true;
	hardware.sensor.iio.enable = true;

# 	services.xserver.wacom.enable = true;
	services.libinput.enable = true;

	hardware.graphics.extraPackages = with pkgs; [
		intel-media-driver
	];

	environment.systemPackages = with pkgs; [
		surface-control
		iio-sensor-proxy
		libcamera
		libiio
	];
}
