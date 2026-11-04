{ inputs, pkgs, ... }:
{
	home.packages = with pkgs;
	[
		# GUI
		ayugram-desktop
		yandex-music
		godot
		vscode
		obsidian
	];

	programs.mpv = {
		enable = true;
		scripts = [ pkgs.mpvScripts.mpris ];
	};

	imports = [ inputs.nixcord.homeModules.nixcord ];

	programs.nixcord = {
		enable = true;
		discord.vencord.enable = true;
		config.plugins.hideMedia.enable = true;
	};
}
