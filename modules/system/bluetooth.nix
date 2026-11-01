{ pkgs, ... }:
{
	hardware.bluetooth = {
		enable = true;
		powerOnBoot = true;
		settings = {
			General = {
				ControllerMode = "bredr";
				JustWorksRepairing = "always";
				UserspaceHID = true;
			};
		};
	};

	environment.systemPackages = with pkgs; [ bluez ];
}
