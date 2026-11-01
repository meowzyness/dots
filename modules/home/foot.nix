{ ... }:
{
	programs.foot = {
		enable = true;

		settings = {
			main = {
				# font = "${theme.font.name}:size=12";
				# font = "${theme.font.name}:size=12:slant=italic";
				term = "xterm-256color";

				pad = "15x20";
			};

			scrollback = {
				lines = 10000;
				multiplier = 3;
			};

			cursor = {
				style = "beam";
				unfocused-style = "hollow";
				blink = "no";
				underline-thickness = "1.5";
			};

			mouse = {
				hide-when-typing = "yes";
			};

			bell = {
				urgent = "no";
				notify = "no";
			};

			"key-bindings" = {
				# clipboard
				clipboard-copy = "Control+Shift+c";
				clipboard-paste = "Control+v";

				# scrollback
				scrollback-up-line = "Control+Up";
				scrollback-down-line = "Control+Down";
				scrollback-up-page = "Control+Shift+Up";
				scrollback-down-page = "Control+Shift+Down";

				# font size
				font-decrease = "Control+minus";
				font-increase = "Control+equal Control+plus";
				font-reset = "Control+0";

				# new terminal
				spawn-terminal = "Control+Shift+Return";
			};
		};
	};
}
