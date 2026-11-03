{ pkgs, ... }:
{
	programs.fish = {
		enable = true;

		plugins = [ ];

		loginShellInit = ''
			doas chronyc makestep 1>/dev/null
		'';

		interactiveShellInit = ''
			set -g fish_greeting ""
			set -g EDITOR micro
		'';

		functions = {
			colored = ''PAGER=cat unbuffer fish -ic "stty -onlcr; $argv"'';

			### CONFIGURATION #####################################################################################################################################################################################
			renixos = "nh os switch ~/dots $argv";
			cnixos = "zf ~/dots/modules";
			cflake = "edit ~/dots/flake.nix";

			rn = "renixos";
			cn = "cnixos";
			cf = "cflake";


			### PACKAGES ##########################################################################################################################################################################################
			search = "nix-search $argv";
			lspacs = "nix profile list --json | jq -r '.elements | keys[]' $argv";
			delete = "nix profile remove $argv";
			update = "nix flake update --flake ~/dots";


			get = ''
				set -l pkgs
				for pkg in $argv
					set -a pkgs nixpkgs#$pkg
				end
				NIXPKGS_ALLOW_UNFREE=1 nix profile add --impure $pkgs
			'';

			try = ''
				set -l pkgs
				for pkg in $argv
					set -a pkgs nixpkgs#$pkg
				end
				NIXPKGS_ALLOW_UNFREE=1 nix shell --impure $pkgs
			'';

			run = ''
				NIXPKGS_ALLOW_UNFREE=1 nix run --impure "nixpkgs#$argv[1]" -- "$argv[2..-1]"
			'';

			gf = # Get packages using Fzf
			''
				if test -z "$argv"
					return 1
				end
				colored search -q "$argv" | fz --preview "colored search -m 1 -d {}" | cut -d " " -f 1 | read -l input; get $input
			'';

			tf = # Throw away packages using Fzf
			''
				lspacs | grep "$argv" | fz --preview "nix profile list --json | jq -C '{\"{}\" : .elements.\"{}\"}'" | read -l input; delete $input
				test $status -eq 0 && tf
			'';


			### NAVIGATION ########################################################################################################################################################################################
			edit = "flow $argv";
			copy = "cp -rv $argv";
			move = "mv -fv $argv";
			create = "mkdir -p $argv";
			rename = "mv -vf --no-copy --no-clobber --strip-trailing-slashes -v $argv";
			remove = "rip $argv";
			seance = "rip -s $argv";
			revive = "rip -u $argv";

			ez = "eza --oneline --classify --color always --icons always --dereference $argv";
			tree = "ez -T $argv";
			fz = "fzf --ansi --preview-window right:60% $argv";
			rg = "batgrep $argv";

			get_filename_only = ''
				set -l input_string
				read input_string
				test -n "$argv" && set -l input_string "$argv"

				set -l len (string length "$input_string")

				for i in (seq $len)
					set -l char (string sub --start=$i --length=1 "$input_string")

					# get the Unicode decimal value
					set -l val (printf '%d' "'$char" 2>/dev/null)

					# detect Nerd Font PUA ranges
					if test -n "$val"
						if test $val -ge 57344 -a $val -le 63743; \
							or test $val -ge 983040 -a $val -le 1048573

							set -l after_icon (string sub --start=(math $i + 1) "$input_string")
							echo (string trim "$after_icon")

							return 0
						end
					end
				end

				echo "$input_string"
			'';


			pv = # preview file or directory
			''
				if test -z "$argv"
					ez $PWD
				else if test (identify "$argv" 2>/dev/null | cut -d ' ' -f 2)
					chafa -f sixels -s 50x10 $argv
				else if test -f "$argv"
					bat --color always --style plain $argv
				else
					ez $argv
				end
			'';

			zx = # zoxide or edit
			''
				if test -f "$argv"
					edit "$argv"
				else
					z $argv
				end
			'';

			zf = # zoxide and fzf
			''
				test -z "$argv" || zx $argv
				set -l path (ez -a | fz --preview 'pv (get_filename_only {})' | get_filename_only)
				test "$status" -ne 0 && return
				test -d "$path" && zf "$path"
				test -f "$path" && edit "$path"
			'';

			rf = # remove files with fzf
			''
				zx .
				set -l path (ez -a | fz --preview 'pv (get_filename_only {})')
				test -e "$path" && remove "./$path" && rf "$argv"
			'';

			uf = # revive files with fzf
			''
				zx $argv
				set -l path (seance | cut -d '/' -f 4- | cut -c (string length $PWD/)- | fz --preview 'pv /tmp/graveyard-$USER$PWD/{}')
				test ! -z "$path" && revive "/tmp/graveyard-$USER$PWD/$path" && uf "$argv"
			'';


			### FUN ###############################################################################################################################################################################################
			randomfile = ''
				find $argv -type f -print0 | shuf -zn1
			'';

			say = "toilet --gay -f mono12 -F border $argv";

			ff = # fastfetch
			''
				if test $COLUMNS -lt 58
					clear
				else if test $COLUMNS -lt 83
					mf
				else
					clear; fastfetch $argv
				end
			'';

			mf = # minifetch
			''
				clear; fastfetch $argv --logo small -c ~/config/fastfetch/small.jsonc
			'';

			fish_prompt = {
				body = ''
					set -l code $status
					set -l u (string sub -l 1 -- "$USER")
					set -l h (string sub -l 1 -- (hostname))
					set -l git (fish_git_prompt)
					set -l time (math round $CMD_DURATION / 1000)

					if test $code -ne 0
						set_color red
						printf '%d ' $code
					end

					if test $time -ge 10
						set_color brblack
						printf '%ss ' $time
					end

					if test $code -eq 0 -a $time -lt 10
						set_color brblack
						printf '%s@%s ' "$u" "$h"
					end

					set_color cyan
					printf '%s' (prompt_pwd)

					if test -n "$git"
						set_color yellow
						printf ' %s' "$git"
					end

					set_color cyan
					printf ' λ  '
					set_color normal
				'';
			};
		};
	};
}
