{ pkgs, inputs, ... }:
{
	programs.hyprland = {
		enable = true;
		package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
	};
	programs.dconf.enable = true;

	services.greetd = {
		enable = true;
		settings = {
			initial_session = {
				command = "start-hyprland";
				user = "meowzy";
			};
			default_session = {
				command = "start-hyprland";
				user = "meowzy";
			};
		};
	};

	# Wayland
	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			# xdg-desktop-portal-hyprland
			xdg-desktop-portal-gtk
		];
		config.common.default = "*";
	};
}
