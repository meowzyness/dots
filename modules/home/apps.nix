# Graphical apps
{ pkgs, ... }:
{
	home.packages = with pkgs;
	[
		# GUI
		ayugram-desktop
		vesktop
		yandex-music
		godot
		vscode
		obsidian
	];

	programs.mpv = {
		enable = true;
		scripts = [ pkgs.mpvScripts.mpris ];
	};
}
