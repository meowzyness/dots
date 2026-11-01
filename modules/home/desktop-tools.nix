# Wayland helpers for the Hyprland binds: clipboard, recording, color picker
{ pkgs, ... }:
{
	home.packages = with pkgs;
	[
		# UTILITY
		wl-clipboard
		wf-recorder
		hyprpicker
	];
}
