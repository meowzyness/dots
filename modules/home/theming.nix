{ pkgs, ... }:
{
	gtk = {
		enable = true;
	};
	fonts.fontconfig.enable = true;

	qt = {
		enable = true;
	};

	home.packages = with pkgs; [
		adwaita-qt
		adwaita-qt6
		adwaita-icon-theme
	];
}
