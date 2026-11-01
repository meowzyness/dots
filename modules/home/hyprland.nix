{ config, lib, pkgs, inputs, ... }:
let
	startup = commands:
	{
		_args = [
			"hyprland.start"
			(lib.generators.mkLuaInline ''
				function()
				${lib.concatMapStringsSep "\n"
					(command: "hl.exec_cmd(${builtins.toJSON command})")
					commands
				}
				end
			'')
		];
	};

	exec = command:
		"hl.dsp.exec_cmd(${builtins.toJSON command})";

	workspace = value:
		"hl.dsp.focus({ workspace = ${builtins.toJSON value} })";

	moveWindow = direction:
		"hl.dsp.window.move({ direction = ${builtins.toJSON direction} })";

	moveToWorkspace = value:
		"hl.dsp.window.move({ workspace = ${builtins.toJSON value} })";

	toggleFloating =
		''hl.dsp.window.float({ action = "toggle" })'';

	toggleFullscreen =
		''hl.dsp.window.fullscreen({
			mode = "fullscreen",
			action = "toggle",
		})'';

	bind =
		key:
		action:
		{
			_args = [
				key
				(lib.generators.mkLuaInline action)
				{ }
			];
		};

	binde =
		key:
		action:
		{
			_args = [
				key
				(lib.generators.mkLuaInline action)
				{ repeating = true; }
			];
		};

	bindm =
		key:
		action:
		{
			_args = [
				key
				(lib.generators.mkLuaInline action)
				{ mouse = true; }
			];
		};

	mkBezier =
		{
			name,
			points,
		}:
		let
			luaPoints = lib.concatStringsSep ", " (
				map
				(point:
					"{
						${toString (builtins.elemAt point 0)},
						${toString (builtins.elemAt point 1)}
					}"
				)
				points
			);
		in
			''hl.curve("${name}", {
				type = "bezier",
				points = { ${luaPoints} },
			})'';

	mkAnimation =
		{
			leaf,
			enabled ? true,
			speed ? null,
			bezier ? null,
			spring ? null,
			style ? null,
		}:

		assert enabled -> speed != null;
		assert !(bezier != null && spring != null);

		let
			fields =
			[
				"leaf = ${builtins.toJSON leaf}"
				"enabled = ${if enabled then "true" else "false"}"
			]
			++ lib.optional (enabled && speed != null)
				"speed = ${builtins.toJSON speed}"
			++ lib.optional (enabled && bezier != null)
				"bezier = ${builtins.toJSON bezier}"
			++ lib.optional (enabled && spring != null)
				"spring = ${builtins.toJSON spring}"
			++ lib.optional (enabled && style != null)
				"style = ${builtins.toJSON style}";
		in
			"hl.animation({ ${lib.concatStringsSep ", " fields} })";

	mkAnimations = animations:
		lib.concatStringsSep "\n" (map mkAnimation animations);
in
{
	stylix.targets.hyprland.enable = true;
	wayland.windowManager.hyprland = {
		enable = true;
		package = null;
		# package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
		# portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
		portalPackage = null;

		plugins = [
			inputs.hyprgrass.packages.${pkgs.stdenv.hostPlatform.system}.default
			# inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
		];

		configType = "lua";


		settings = {
			config = {
				xwayland.force_zero_scaling = true;

				animations.enabled = true;

				input = {
					kb_layout = "us, ru";
					# kb_variant = qwerty;
					kb_options = "grp:alt_shift_toggle";

					follow_mouse = 1;
					sensitivity = 0.2;
					force_no_accel = false;

					# scroll_factor = 1.0;
					natural_scroll = false;

					touchpad = {
						natural_scroll = true;
						# scroll_factor = 0.5;
						clickfinger_behavior = true;
						disable_while_typing = true;
					};
				};

				general = {
					gaps_in = 2;
					gaps_out = 10;
					border_size = 0;
					layout = "master";
				};

				master = {
					mfact = 0.60;
					new_on_top = true;
					orientation = "left";
				};

				decoration = {
					rounding = 10;
					inactive_opacity = 0.9;
					dim_inactive = false;
					dim_strength = 0.25;

					shadow = {
						enabled = false;
						render_power = 4;
						range = 5;
					};

					blur = {
						enabled = true;
						size = 5;
						passes = 5;
					};
				};


				gestures = {
					workspace_swipe_distance = 1000;
					workspace_swipe_min_speed_to_force = 10;
					workspace_swipe_create_new = true;
				};

				plugin = {
					hyprgrass = {
						sensitivity = 1.5;
						long_press_delay = 400;
						resize_on_border_long_press = true;
						edge_margin = 50;
					};
				};

				misc = {
					# no, i dont want anime girls on my wallpaper, thank you
					disable_splash_rendering = true;
					disable_hyprland_logo = true;
					force_default_wallpaper = 0;

					middle_click_paste = false;
					# new_window_takes_over_fullscreen = 1;
					exit_window_retains_fullscreen = true;
				};
			};
			# monitor = [ "eDP-1, 2880x1920@60, 0x0, 2" ",preferred, auto, 1" ];

			on = [
				(startup [
					"noctalia"
					"vicinae server"
					"clash-verge"
					"foot -s"
				])
			];

			# Window rules
			window_rule = [
				{
					match.class = "^xwayland$";
					no_blur = true;
				}
			];

			bind = [
				# logout
				(bind "ALT + BACKSPACE"
				(exec "noctalia msg panel-open session"))

				(bind "XF86PowerOff"
				(exec "noctalia msg panel-open session"))

				# screen capture / recording
				(bind "SUPER + S"
				(exec "noctalia msg screenshot-fullscreen all"))

				(bind "SUPER + ALT + S"
				(exec "noctalia msg screenshot-region"))

				# shell
				(bind "ALT + W"
				(exec "noctalia msg panel-open control-center"))

				(bind "ALT + E"
				(exec "noctalia msg panel-open tray-drawer"))

				(bind "ALT + V"
				(exec "noctalia msg panel-open clipboard"))

				(bind "ALT + U"
				(exec "noctalia msg panel-open control-center bluetooth"))

				(bind "ALT + I"
				(exec "noctalia msg panel-open control-center network"))

				(bind "ALT + RETURN"
				(exec "noctalia msg panel-open launcher"))


				# apps
				(binde "SUPER + K"
				(exec "footclient"))

				(bind "SUPER + A"
				(exec "kitty"))

				(bind "SUPER + T"
				(exec "AyuGram"))

				(bind "SUPER + Z"
				(exec "zen-beta"))

				(bind "SUPER + P"
				(exec "hyprpicker | wl-copy"))

				# specialisations
				(bind "SUPER + F"
				(exec "~/.local/state/home-manager/gcroots/current-home/specialisation/focus/activate"))
				(bind "SUPER + D"
				(exec "doas systemctl restart home-manager-$USER.service"))

				# windows
				(bind "ALT + TAB"
				"hl.dsp.layout('cyclenext')")
				(binde "ALT + Q"
				"hl.dsp.window.close()")
				# "SUPER, Q, exec, hyprctl kill"

				# # tags
				(bind "ALT + ESCAPE"
				toggleFloating)
				(bind "ALT + F"
				toggleFullscreen)

				# mouse
				# "SUPER, mouse:274, killactive"

				# move window
				(bind "SUPER + ALT + RIGHT" (moveWindow "right"))
				(bind "SUPER + ALT + LEFT" (moveWindow "left"))
				(bind "SUPER + ALT + UP" (moveWindow "up"))
				(bind "SUPER + ALT + DOWN" (moveWindow "down"))

				# move focus
				# "CTRL_ALT, RIGHT, movefocus, r"
				# "CTRL_ALT, LEFT,  movefocus, l"
				# "CTRL_ALT, UP,	movefocus, u"
				# "CTRL_ALT, DOWN,  movefocus, d"

				# workspaces
				(bind "SUPER + 1" (workspace "1"))
				(bind "SUPER + 2" (workspace "2"))
				(bind "SUPER + 3" (workspace "3"))
				(bind "SUPER + 4" (workspace "4"))
				(bind "SUPER + 5" (workspace "5"))
				(bind "SUPER + 6" (workspace "6"))
				(bind "SUPER + ESCAPE" (workspace "empty"))

				# audio
				(bind "XF86AudioMute" (exec "noctalia msg volume-mute"))
				(binde "XF86AudioRaiseVolume"
				(exec "noctalia msg volume-up"))

				(binde "XF86AudioLowerVolume"
				(exec "noctalia msg volume-down"))

				# brightness
				(binde "XF86MonBrightnessUp"
				(exec "noctalia msg brightness-up"))

				(binde "XF86MonBrightnessDown"
				(exec "noctalia msg brightness-down"))

				# workspaces
				(binde "SUPER + RIGHT" (workspace "+1"))
				(binde "SUPER + LEFT" (workspace "-1"))

				(binde "SUPER + CTRL + RIGHT" (moveToWorkspace "+1"))
				(binde "SUPER + CTRL + LEFT" (moveToWorkspace "-1"))

				# mouse window management
				(bindm "SUPER + mouse:272"
				"hl.dsp.window.drag()")

				(bindm "SUPER + mouse:273"
				"hl.dsp.window.resize()")
			];
		};
		extraConfig = ''
			hl.gesture({
				fingers = 3,
				direction = "horizontal",
				action = "workspace",
			})

			hl.plugin.hyprgrass.gesture({
				pattern = {
					kind = "swipe",
					fingers = 3,
					direction = "down",
				},
				action = "close",
			})

			hl.plugin.hyprgrass.gesture({
				pattern = {
					kind = "pinch",
					fingers = 3,
					direction = "pinchout",
				},
				action = "close",
			})

			hl.plugin.hyprgrass.bind({
				pattern = {
					kind = "edge",
					origin = "right",
					direction = "left",
					fingers = 1,
				},
				action = hl.dsp.focus({ workspace = "+1" }),
				non_consuming = true,
			})

			hl.plugin.hyprgrass.bind({
				pattern = {
					kind = "edge",
					origin = "left",
					direction = "right",
					fingers = 1,
				},
				action = hl.dsp.focus({ workspace = "-1" }),
				non_consuming = true,
			})

			hl  .plugin.hyprgrass.bind({
				pattern = {
					kind = "edge",
					origin = "down",
					direction = "up",
					fingers = 1,
				},
				action = hl.dsp.exec_cmd("pkill wvkbd-mobintl || wvkbd-mobintl -L 300 -R 5 --landscape-layers simple,special,cyrillic"),
			})

			hl.plugin.hyprgrass.bind({
				pattern = {
					kind = "edge",
					origin = "up",
					direction = "down",
					fingers = 1,
				},
				action = hl.dsp.exec_cmd("noctalia msg panel-open launcher"),
			})

			hl.plugin.hyprgrass.bind({
				pattern = {
					kind = "longpress",
					fingers = 2,
				},
				action = hl.dsp.window.drag(),
				mouse = true,
				non_consuming = true,
			})

			hl.plugin.hyprgrass.bind({
				pattern = {
					kind = "pinch",
					fingers = 3,
					direction = "pinchin",
				},
				action = hl.dsp.window.fullscreen({
					mode = "fullscreen",
					action = "toggle",
					non_consuming = true,
				}),
			})

			${
				let curves = [
					(mkBezier {
						name = "fast";
						points = [
							[ 0.16 1.0 ]
							[ 0.30 1.0 ]
						];
					})

					(mkBezier {
						name = "smooth";
						points = [
							[ 0.22 1.0 ]
							[ 0.36 1.0 ]
						];
					})

					(mkBezier {
						name = "linear";
						points = [
							[ 0.0 0.0 ]
							[ 1.0 1.0 ]
						];
					})
				];
				in lib.concatStringsSep "\n\n" curves
			}

			${
			mkAnimations [
				{
					leaf = "global";
					speed = 3;
					bezier = "fast";
				}

				{
					leaf = "windows";
					speed = 3;
					bezier = "fast";
				}

				{
					leaf = "windowsIn";
					speed = 3;
					bezier = "fast";
					style = "popin 85%";
				}

				{
					leaf = "windowsOut";
					speed = 2;
					bezier = "fast";
					style = "popin 85%";
				}

				{
					leaf = "windowsMove";
					speed = 3;
					bezier = "fast";
				}

				{
					leaf = "layers";
					speed = 3;
					bezier = "fast";
				}

				{
					leaf = "layersIn";
					speed = 3;
					bezier = "fast";
					style = "popin";
				}

				{
					leaf = "layersOut";
					speed = 2;
					bezier = "fast";
					style = "popin";
				}

				{
					leaf = "fade";
					speed = 2;
					bezier = "smooth";
				}

				{
					leaf = "fadeIn";
					speed = 2;
					bezier = "smooth";
				}

				{
					leaf = "fadeOut";
					speed = 2;
					bezier = "smooth";
				}

				{
					leaf = "workspaces";
					speed = 3;
					bezier = "fast";
					style = "slide";
				}

				{
					leaf = "workspacesIn";
					speed = 3;
					bezier = "fast";
					style = "slide";
				}

				{
					leaf = "workspacesOut";
					speed = 2;
					bezier = "fast";
					style = "slide";
				}

				{
					leaf = "border";
					speed = 2;
					bezier = "fast";
				}

				{
					leaf = "borderangle";
					speed = 3;
					bezier = "linear";
					style = "loop";
				}
			]}
		'';
	};
}
