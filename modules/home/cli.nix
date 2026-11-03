# Terminal tools: CLI and TUI
{ pkgs, ... }:
{
	home.packages = with pkgs;
	[
		# CLI
		git
		gnumake
		zip unzip
		jq

		rm-improved
		fd
		eza
		fzf
		skim
		tldr

		bat-extras.batdiff
		bat-extras.batgrep
		bat-extras.batman

		chafa
		fastfetch
		fetch
		cmatrix
		cbonsai


		# TUI
		flow-control
		github-cli
		ani-cli
		bottom
		jolt-tui
	];

	programs.zoxide.enable = true;
	programs.bat.enable = true;
	programs.direnv = {
		enable = true;
		nix-direnv.enable = true;
	};
}
