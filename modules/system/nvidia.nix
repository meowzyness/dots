{ config, ... }:
{
	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		open = true;
		modesetting.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

	environment.sessionVariables = {
		LIBVA_DRIVER_NAME = "nvidia"; # video decoding
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
		NVD_BACKEND = "direct";
	};
}
