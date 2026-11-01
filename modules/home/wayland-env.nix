{ ... }:
{
	home.sessionVariables = {
		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";
		_JAVA_AWT_WM_NONREPARENTING = "1";
		GDK_BACKEND = "wayland,x11,*";
		QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
		QT_QPA_PLATFORM = "wayland;xcb";
		CLUTTER_BACKEND = "wayland";
	};
}
