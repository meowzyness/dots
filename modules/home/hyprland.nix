{ lib, pkgs, inputs, ... }:
let
	# converts raw lua to inline lua statement that can be used alongside nix code that will be translated to lua
	lua = lib.generators.mkLuaInline;

	# converts list to comma-seperated raw lua arguments
	renderArgs = args:
		lib.concatMapStringsSep ", " (arg: lib.generators.toLua {} arg) args;

	# generates an inline lua function call, from function name and argument list
	call = fn: args:
	lib.generators.mkLuaInline "${fn}(${renderArgs args})";

	# converts a list of inline lua function calls to raw lua
	renderCalls = calls:
	lib.concatMapStringsSep "\n" (luaCall: luaCall.expr) calls;

	startup = commands:
		{
			_args = [
				"hyprland.start"
				(lua ''
					function()
						${renderCalls commands}
					end
				'')
			];
		};


	exec_cmd = command:
		call "hl.exec_cmd" [
			command
		];

	exec = command:
		call "hl.dsp.exec_cmd" [
			command
		];

	workspace = value:
		call "hl.dsp.focus" [
			{ workspace = value; }
		];

	focus = value:
		call "hl.dsp.layout" [
			"focus ${value}"
		];

	window = {
		move = value:
			call "hl.dsp.window.move" [
				{ direction = value; }
			];

		moveToWorkspace = value:
			call "hl.dsp.window.move" [
				{ workspace = value; }
			];

		float =
			call "hl.dsp.window.float" [
				{ action = "toggle"; }
			];

		fullscreen =
			call "hl.dsp.window.fullscreen" [
				{
					mode = "fullscreen";
					action = "toggle";
				}
			];

		close = call "hl.dsp.window.close" [];
		drag = call "hl.dsp.window.drag" [];
		resize = call "hl.dsp.window.resize" [];
	};

	bind = key: action:
		{
			_args = [
				key
				action
				{ }
			];
		};

	binde = key: action:
		{
			_args = [
				key
				action
				{ repeating = true; }
			];
		};

	bindm = key: action:
		{
			_args = [
				key
				action
				{ mouse = true; }
			];
		};
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
					layout = "scrolling";
				};

				master = {
					mfact = 0.60;
					new_on_top = true;
					orientation = "left";
				};

				scrolling = {
					column_width = 0.9;
					fullscreen_on_one_column = true;
					direction = "right";
					wrap_focus = true;
# 					focus_fit_method = 0;
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
					workspace_swipe_touch = true;
					workspace_swipe_cancel_ratio = 0.15;

					workspace_swipe_distance = 1000;
					workspace_swipe_min_speed_to_force = 10;
					workspace_swipe_create_new = true;
				};

				plugin = {
					hyprgrass = {
						sensitivity = 1.5;
						long_press_delay = 400;
						resize_on_border_long_press = true;
						edge_margin = 75;
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
					(exec_cmd "noctalia -d")
					(exec_cmd "clash-verge-service")
					(exec_cmd "foot -s")
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
				# SHELL

				# logout
				(bind "ALT + BACKSPACE"
				(exec "noctalia msg panel-toggle session"))

				(bind "XF86PowerOff"
				(exec "noctalia msg panel-toggle session"))

				# screen capture / recording
				(bind "SUPER + S"
				(exec "noctalia msg screenshot-fullscreen all"))

				(bind "SUPER + ALT + S"
				(exec "noctalia msg screenshot-region"))

				# other shell stuff
				(bind "ALT + W"
				(exec "noctalia msg panel-toggle control-center"))

				(bind "ALT + E"
				(exec "noctalia msg panel-toggle tray-drawer"))

				(bind "ALT + V"
				(exec "noctalia msg panel-toggle clipboard"))

				(bind "ALT + U"
				(exec "noctalia msg panel-toggle control-center bluetooth"))

				(bind "ALT + I"
				(exec "noctalia msg panel-toggle control-center network"))

				(bind "ALT + RETURN"
				(exec "noctalia msg panel-toggle launcher"))

				# audio
				(bind "XF86AudioMute"
				(exec "noctalia msg volume-mute"))

				(binde "XF86AudioRaiseVolume"
				(exec "noctalia msg volume-up"))

				(binde "XF86AudioLowerVolume"
				(exec "noctalia msg volume-down"))

				# brightness
				(binde "XF86MonBrightnessUp"
				(exec "noctalia msg brightness-up"))

				(binde "XF86MonBrightnessDown"
				(exec "noctalia msg brightness-down"))



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
				(binde "ALT + TAB"
				(focus "down"))
				(binde "ALT + Q"
				window.close)

				(bind "ALT + ESCAPE"
				window.float)
				(bind "ALT + F"
				window.fullscreen)



				# SUPER - indicates any layout focus update
				# ALT - means action is local to current workspace, otherwise it can switch workspaces
				# CTRL - means grab the window too


				# inside workspace only
				(binde "ALT + SUPER + RIGHT" (focus "right"))
				(binde "ALT + SUPER + LEFT" (focus "left"))
				(binde "ALT + SUPER + UP" (focus "up"))
				(binde "ALT + SUPER + DOWN" (focus "down"))

				# inside workspace only + grab
				(bind "ALT + SUPER + CTRL + RIGHT" (window.move "right"))
				(bind "ALT + SUPER + CTRL + LEFT" (window.move "left"))
				(bind "ALT + SUPER + CTRL + UP" (window.move "up"))
				(bind "ALT + SUPER + CTRL + DOWN" (window.move "down"))


				# auto
				(binde "SUPER + LEFT" (focus "left"))
				(binde "SUPER + RIGHT" (focus "right"))
				(binde "SUPER + UP" (workspace "-1"))
				(binde "SUPER + DOWN" (workspace "+1"))

				# auto + grab
				(bind "SUPER + CTRL + LEFT" (window.move "left"))
				(bind "SUPER + CTRL + RIGHT" (window.move "right"))
				(binde "SUPER + CTRL + UP" (window.moveToWorkspace "-1"))
				(binde "SUPER + CTRL + DOWN" (window.moveToWorkspace "+1"))



				# workspaces
				(bind "SUPER + 1" (workspace "1"))
				(bind "SUPER + 2" (workspace "2"))
				(bind "SUPER + 3" (workspace "3"))
				(bind "SUPER + 4" (workspace "4"))
				(bind "SUPER + 5" (workspace "5"))
				(bind "SUPER + 6" (workspace "6"))
				(bind "SUPER + ESCAPE" (workspace "empty"))

				# mouse window management
				(bindm "SUPER + mouse:272"
				window.drag)

				(bindm "SUPER + mouse:273"
				window.resize)
			];
		};
		extraConfig = renderCalls [
			(call "hl.gesture" [
				{
					fingers = 3;
					direction = "vertical";
					action = "workspace";
				}
			])

			(call "hl.gesture" [
				{
					fingers = 3;
					direction = "horizontal";
					action = "scroll_move";
				}
			])

			(call "hl.plugin.hyprgrass.gesture" [
				{
					pattern = {
						kind = "swipe";
						fingers = 3;
						direction = "vertical";
					};
					action = "workspace";
				}
			])

			(call "hl.plugin.hyprgrass.gesture" [
				{
					pattern = {
						kind = "pinch";
						fingers = 4;
						direction = "pinchout";
					};
					action = "close";
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
				{
					pattern = {
						kind = "edge";
						origin = "down";
						direction = "up";
					};
					action = (workspace "+1");
					non_consuming = true;
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
				{
					pattern = {
						kind = "edge";
						origin = "up";
						direction = "down";
					};
					action = (workspace "+1");
					non_consuming = true;
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
				{
					pattern = {
						kind = "edge";
						origin = "left";
						direction = "right";
					};
					action = (focus "left");
					non_consuming = true;
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
			{
				pattern = {
					kind = "edge";
					origin = "right";
					direction = "left";
				};
					action = (focus "right");
					non_consuming = true;
				}
			])

			(call "hl.plugin.hyprgrass.gesture" [
				{
					pattern = {
						kind = "swipe";
						fingers = 2;
						direction = "up";
					};
					action = lua ''
						function()
							hl.exec_cmd(
								"pkill wvkbd-mobintl || wvkbd-mobintl -L 300 -R 5 --landscape-layers simple,special,cyrillic"
							)
						end
					'';
				}
			])

			(call "hl.plugin.hyprgrass.gesture" [
				{
					pattern = {
						kind = "swipe";
						fingers = 2;
						direction = "down";
					};
					action = lua ''
						function()
							hl.exec_cmd("noctalia msg panel-toggle launcher")
						end
					'';
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
				{
					pattern = {
						kind = "longpress";
						fingers = 2;
					};
					action = window.drag;
					mouse = true;
					non_consuming = true;
				}
			])

			(call "hl.plugin.hyprgrass.bind" [
				{
					pattern = {
						kind = "pinch";
						fingers = 3;
						direction = "pinchin";
					};
					action = window.fullscreen;
				}
			])

			(call "hl.curve" [
				"fast"
				{
					type = "bezier";
					points = [
						[ 0.160000 1.000000 ]
						[ 0.300000 1.000000 ]
					];
				}
			])

			(call "hl.curve" [
				"smooth"
				{
					type = "bezier";
					points = [
						[ 0.220000 1.000000 ]
						[ 0.360000 1.000000 ]
					];
				}
			])

			(call "hl.curve" [
				"linear"
				{
					type = "bezier";
					points = [
						[ 0.000000 0.000000 ]
						[ 1.000000 1.000000 ]
					];
				}
			])

			(call "hl.animation" [{
				leaf = "global";
				enabled = true;
				speed = 3;
				bezier = "fast";
			}])

			(call "hl.animation" [{
				leaf = "windows";
				enabled = true;
				speed = 3;
				bezier = "fast";
			}])

			(call "hl.animation" [{
				leaf = "windowsIn";
				enabled = true;
				speed = 3;
				bezier = "fast";
				style = "popin 85%";
			}])

			(call "hl.animation" [{
				leaf = "windowsOut";
				enabled = true;
				speed = 2;
				bezier = "fast";
				style = "popin 85%";
			}])

			(call "hl.animation" [{
				leaf = "windowsMove";
				enabled = true;
				speed = 3;
				bezier = "fast";
			}])

			(call "hl.animation" [{
				leaf = "layers";
				enabled = true;
				speed = 3;
				bezier = "fast";
			}])

			(call "hl.animation" [{
				leaf = "layersIn";
				enabled = true;
				speed = 3;
				bezier = "fast";
				style = "popin";
			}])

			(call "hl.animation" [{
				leaf = "layersOut";
				enabled = true;
				speed = 2;
				bezier = "fast";
				style = "popin";
			}])

			(call "hl.animation" [{
				leaf = "fade";
				enabled = true;
				speed = 2;
				bezier = "smooth";
			}])

			(call "hl.animation" [{
				leaf = "fadeIn";
				enabled = true;
				speed = 2;
				bezier = "smooth";
			}])

			(call "hl.animation" [{
				leaf = "fadeOut";
				enabled = true;
				speed = 2;
				bezier = "smooth";
			}])

			(call "hl.animation" [{
				leaf = "workspaces";
				enabled = true;
				speed = 3;
				bezier = "fast";
				style = "slidevert";
			}])

			(call "hl.animation" [{
				leaf = "workspacesIn";
				enabled = true;
				speed = 3;
				bezier = "fast";
				style = "slidevert";
			}])

			(call "hl.animation" [{
				leaf = "workspacesOut";
				enabled = true;
				speed = 2;
				bezier = "fast";
				style = "slidevert";
			}])

			(call "hl.animation" [{
				leaf = "border";
				enabled = true;
				speed = 2;
				bezier = "fast";
			}])

			(call "hl.animation" [{
				leaf = "borderangle";
				enabled = true;
				speed = 3;
				bezier = "linear";
				style = "loop";
			}])
		];
	};
}
