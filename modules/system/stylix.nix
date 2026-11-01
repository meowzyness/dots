{ pkgs, ... }:
{
	stylix = {
		enable = true;
		polarity = "dark";

		image = ../../wallpaper.jpg;
		base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-soft.yaml";

		fonts = {
			monospace = {
				package = pkgs.maple-mono.NF;
				name = "Maple Mono NF";
			};

			sansSerif = {
				package = pkgs.maple-mono.CN;
				name = "Maple Mono NF";
			};

			serif = {
				package = pkgs.maple-mono.CN;
				name = "Maple Mono NF";
			};

			emoji = {
				package = pkgs.noto-fonts-color-emoji;
				name = "Noto Color Emoji";
			};

			sizes = {
				applications = 12;
				desktop = 12;
				terminal = 12;
				popups = 12;
			};
		};

		cursor = {
			package = pkgs.phinger-cursors;
			name = "phinger-cursors-dark";
			size = 24;
		};

		icons = {
			enable = true;
			package = pkgs.papirus-icon-theme;
			dark = "Papirus-Dark";
			light = "Papirus";
		};
	};
}