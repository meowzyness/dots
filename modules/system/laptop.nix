{ pkgs, ... }:
{
	# services.tlp.enable = true;
	# powerManagement.powertop.enable = true;
	powerManagement.enable = true;
	services.upower.enable = true;
	services.power-profiles-daemon.enable = true;

	services.logind.settings.Login = {
		HandlePowerKey = "suspend";
		# LidSwitch = "ignore";
		HandleLidSwitch = "suspend";
		HandleLidSwitchExternalPower = "suspend";
		HandleLidSwitchDocked = "suspend";
		PowerKeyIgnoreInhibited = "yes";
		HandlePowerKeyLongPress = "poweroff";
	};

	systemd.services.resuspend-when-lid-closed = {
		wantedBy = [ "multi-user.target" ];
		script = ''
			${pkgs.fish}/bin/fish <<'FISH'
				while true
					sleep 1
					cat /proc/acpi/button/lid/*/state | grep closed
					if test $status -eq 0
						systemctl suspend
					end
				end
			'FISH'
		'';
	};

	environment.systemPackages = with pkgs; [ powertop ];
}
