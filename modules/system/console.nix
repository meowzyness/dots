{ pkgs, ... }:
{
	console = {
		earlySetup = false;
		keyMap = "us";
		packages = with pkgs; [ terminus_font ];
		font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
	};
}
