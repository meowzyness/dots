{ config, pkgs, inputs, ... }:
{
	imports = [
		inputs.noctalia.homeModules.default
	];

	programs.noctalia = {
		enable = true;
		package = pkgs.noctalia;

		settings = {
			config_version = 14;

			storage = {
				key_source = "file";
				key_file = "${config.home.homeDirectory}/.config/noctalia/storage.key";
			};

			brightness.minimum_brightness = 0.01;
			battery.warning_threshhold = 20;

			shell = {
				button_borders = false;
				card_borders = false;
				input_borders = false;
				popup_borders = false;
				panel_anchor_bar = "widgets";
				password_style = "random";
				screen_time_enabled = true;
				show_location = false;

				animation.speed = 4.0;

				launcher = {
					categories = false;
					providers = {
						emoji.global = false;
						session.global = true;
						wallpaper.global = true;
						windows.global = true;
					};
				};

				panel = {
					launcher_placement = "attached";
					polkit_placement = "attached";
					session_placement = "floating";
					session_position = "top_right";
					open_near_click_control_center = true;
					open_near_click_launcher = true;
					open_near_click_session = true;
				};

				session = {
					grid = true;
					grid_columns = 1;
					actions = [
						{ action = "lock";             shortcut = "1"; variant = "outline";     enabled = true;  countdown_seconds = 0.0; }
						{ action = "logout";           shortcut = "2"; variant = "default";     enabled = true;  countdown_seconds = 0.0; }
						{ action = "reboot";           shortcut = "3"; variant = "default";     enabled = true;  countdown_seconds = 0.0; }
						{ action = "shutdown";         shortcut = "4"; variant = "secondary";   enabled = true;  countdown_seconds = 0.0; }
						{ action = "lock_and_suspend"; shortcut = "3"; variant = "default";     enabled = false; countdown_seconds = 0.0; }
					];
				};

				shadow = {
					alpha = 0.0;
					direction = "center";
				};

				avatar_path = "${config.home.homeDirectory}/files/Downloads/pfp.png";

				clipboard_history_max_entries = 10000;
				clipboard_image_action_command = "satty -f -";

				screen_corners.enabled = false;

				screenshot = {
					confirm_region = true;
					directory = "${config.home.homeDirectory}/files/Pictures/Videos";

					freeze_screen = true;
				};
			};

			bar.widgets = {
				start = [ "workspaces" ];
				center = [ ];
				end = [ "tray" "battery" "clock" ];
				padding = 20;
				margin_edge = 5;
				margin_ends = 10;
				widget_spacing = 15;
				concave_edge_corners = false;
				contact_shadow = true;
			};

			widget = {
				battery = {
					display_mode = "graphic";
					show_label = false;
				};

				clock.actions = {
					left = "panel-toggle control-center";
					middle = "settings-toggle";
				};

				control-center.glyph = "layout-grid-filled";

				launcher = {
					glyph = "snowflake";
					scale = 1.2;
				};

				network.show_label = false;

				tray = {
					drawer = true;
					drawer_columns = 1;
					drawer_item_size = 20.0;
				};
				workspaces = {
					empty_color = "surface_variant";
					occupied_color = "surface_variant";
					show_labels = false;
				};
			};

			control_center = {
				hidden_tabs = [ "weather" "calendar" ];
				sidebar = "full";
				sidebar_section = "full";
				show_shortcut_labels = false;
				shortcuts = map (type: { inherit type; }) [ "wifi" "bluetooth" "nightlight" "notification" "power_profile" "clipboard" ];
			};

			dock = {
				enabled = true;
				auto_hide = true;
				pinned = [ "zen-beta" "yandex-music" ];
				reserve_space = false;
				show_instance_count = false;
			};

			osd = {
				position = "top_right";
				position_vertical = "center_right";
# 				background_opacity = 0.5;
			};

			notification = {
# 				background_opacity = 0.5;
				border = false;
				history_retention_hours = 12;
				max_visible = 2;
			};

			audio = {
				enable_overdrive = true;
				enable_sounds = true;
			};


			wallpaper = {
				directory = "${config.home.homeDirectory}/files/Pictures";
				directory_dark = "${config.home.homeDirectory}/files/Pictures";
				directory_light = "${config.home.homeDirectory}/files/Pictures";
				fill_mode = "stretch";
				transition = [ ];
				automation.interval_seconds = 20;
				default.path = if config.stylix.image != null then "${config.stylix.image}" else "color:${config.lib.stylix.colors.withHashtag.base00}";
			};

			plugins.enabled = [ "noctalia/kaomoji" "noctalia/screen_recorder" "noctalia/wallhaven" ];

			plugin_settings."noctalia/wallhaven" = {
				browser_open_near_click = false;
				download_dir = "";
			};

			desktop_widgets = {
				schema_version = 2;
				grid = {
					cell_size = 8;
					major_interval = 4;
					visible = true;
				};
			};

			idle = {
				behavior_order = [ "screen-off" "lock" "lock-and-suspend" ];
				pre_action_fade_seconds = 30;

				behavior = {
					lock = {
						action = "lock";
						enabled = true;
						timeout = 1000.0;
					};

					lock-and-suspend = {
						action = "lock_and_suspend";
						enabled = false;
						timeout = 1900.0;
					};

					screen-off = {
						action = "screen_off";
						enabled = true;
						locked_timeout = 60.0;
						timeout = 600.0;
					};
				};
			};

			lockscreen = {
				blur_intensity = 1;
				blurred_desktop = true;
				transition = [ "fade" ];
				transition_duration = 500;
			};

			lockscreen_widgets = {
				enabled = true;
				schema_version = 2;
				widget_order = [ "lockscreen-login-box@eDP-1" "lockscreen-widget-0000000000000001" "lockscreen-widget-0000000000000002" ];

				grid = {
					cell_size = 16;
					major_interval = 4;
					visible = true;
				};

				widget."lockscreen-login-box@eDP-1" = {
					box_height = 70.0;
					box_width = 400.0;
					cx = 720.0;
					cy = 576.0;
					output = "eDP-1";
					placement_height = 960.0;
					placement_width = 1440.0;
					rotation = 0.0;
					type = "login_box";

					settings = {
						background_color = "surface_variant";
						background_opacity = 0.0;
						background_radius = 0.0;
						center_password_text = true;
						input_opacity = 0.5;
						input_radius = 32.0;
						layout = "compact";
						show_caps_lock = true;
						show_keyboard_layout = true;
						show_login_button = false;
						show_media = true;
						show_session_buttons = true;
						show_unlock_hint = false;
						show_weather = true;
					};
				};


				widget."lockscreen-widget-0000000000000001" = {
					box_height = 144.0;
					box_width = 352.0;
					cx = 720.0;
					cy = 480.0;
					output = "eDP-1";
					placement_height = 960.0;
					placement_width = 1440.0;
					rotation = 0.0;
					type = "clock";

					settings = {
						background = false;
						clock_style = "digital";
					};
				};

				widget."lockscreen-widget-0000000000000002" = {
					box_height = 128.0;
					box_width = 288.0;
					cx = 160.0;
					cy = 96.0;
					output = "eDP-1";
					placement_height = 960.0;
					placement_width = 1440.0;
					rotation = 0.0;
					type = "media_player";

					settings = {
						background = true;
						background_opacity = 0.5;
						background_padding = 16;
						background_radius = 16;
						hide_when_no_media = true;
						layout = "horizontal";
					};
				};
			};
		};
	};
}
