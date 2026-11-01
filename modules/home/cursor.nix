{ config, ... }:
let theme = config.theme; in
{
	home.pointerCursor = {
		enable = true;
		name = theme.cursor.name;
		package = theme.cursor.package;
		size = theme.cursor.size;
		gtk.enable = true;
		x11.enable = true;
	};
}
