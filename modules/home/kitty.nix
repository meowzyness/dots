{ ... }:
{
	programs.kitty = {
		enable = true;

		settings = {

			# tabs
			tab_bar_edge                = "bottom";
			tab_bar_min_tabs            = 2;
			tab_bar_style               = "powerline";
			tab_powerline_style         = "slanted";
			tab_title_template          = "{title}{' [{}]'.format(num_windows) if num_windows > 1 else ''}";

			# font
			bold_font                   = "auto";
			italic_font                 = "auto";
			bold_italic_font            = "auto";
			font_size                   = 11.0;

			# window
			window_padding_width        = 10;
			dynamic_background_opacity  = true;

			# performance
			repaint_delay               = 0;
			input_delay                 = 0;

			# misc
			confirm_os_window_close     = 0;
			cursor_shape                = "underline";
			cursor_blink_interval       = 0;
			cursor_underline_thickness  = "1.5";
			default_pointer_shape       = "arrow";
			pointer_shape_when_grabbed  = "arrow";
			pointer_shape_when_dragging = "arrow";
			clear_all_shortcuts         = true;

			# bell
			enable_audio_bell           = false;
			visual_bell_duration        = 0;
		};

		extraConfig = ''
			bell_on_tab " "
		'';

		keybindings = {
			# clipboard
			"ctrl+c"           = "copy_or_interrupt";
			"ctrl+shift+c"     = "copy_to_clipboard";
			"ctrl+v"           = "paste_from_clipboard";
			"ctrl+shift+v"     = "paste_from_clipboard";

			# scroll
			"ctrl+up"          = "scroll_line_up";
			"ctrl+down"        = "scroll_line_down";
			"ctrl+shift+up"    = "scroll_page_up";
			"ctrl+shift+down"  = "scroll_page_down";

			# font size
			"ctrl+minus"       = "change_font_size all -1.0";
			"ctrl+equal"       = "change_font_size all +1.0";

			# background opacity
			"ctrl+shift+minus" = "set_background_opacity -0.1";
			"ctrl+shift+equal" = "set_background_opacity +0.1";
			"ctrl+shift+0"     = "set_background_opacity 0";
		};
	};
}
