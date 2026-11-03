{  pkgs, ... }:
{
	programs.appimage = {
		enable = true;
		binfmt = true;
		package = pkgs.appimage-run.override {
			extraPkgs = pkgs: [ pkgs.libepoxy ];
		};
	};

	programs.nix-ld = {
		enable = true;
		libraries = with pkgs; [
			# c, compression, crypto
			stdenv.cc.cc
			zlib
			zstd
			bzip2
			xz
			openssl
			curl
			libxml2
			icu

			# UI, fonts, graphics
			glib
			gtk4
			fontconfig
			freetype
			libxkbcommon
			libGL
			libgbm
			libdrm
			libva
			vulkan-loader

			# X11
			libX11
			libXext
			libXrender
			libXfixes
			libXcomposite
			libXdamage
			libXrandr
			libXcursor
			libXinerama
			libXi
			libXtst
			libXScrnSaver
			libSM
			libICE
			libxcb
			libxcb-cursor

			# desktop services, multimedia
			dbus
			libnotify
			gsettings-desktop-schemas
			pipewire
			ffmpeg
			cups
			nspr
			nss
			libusb1
			SDL2
		];
	};


	nixpkgs.config = {
		allowBroken = true; # idc i just want it to build
		allowUnfree = true;

		# temporary
		problems.handlers = {
			"gtk+".broken = "warn";
		};
	};
	environment.systemPackages = with pkgs; [

	];
}
