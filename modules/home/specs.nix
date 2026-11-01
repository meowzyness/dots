{ pkgs, lib, ... }:
{
	specialisation.focus.configuration = {
		stylix.image = null;
		stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

		wayland.windowManager.hyprland = {
			settings.config = {
				general = {
					gaps_in = lib.mkForce 0;
					gaps_out = lib.mkForce 0;
				};

				decoration = {
					rounding = lib.mkForce 0;
					inactive_opacity = lib.mkForce 1;
					dim_inactive = lib.mkForce true;
					shadow.enabled = lib.mkForce false;
				};

				animations.enabled = lib.mkForce false;
			};
		};


		programs.noctalia.settings = {
			shell = {
				corner_radius_scale = 0;
				animation.enabled = false;
			};

			bar.widgets = {
				radius = lib.mkForce 0;
				margin_edge = lib.mkForce 0;
				margin_ends = lib.mkForce 0;
			};
		};
	};
}
