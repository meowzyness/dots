{ pkgs, ... }:
{
	home.packages = with pkgs;
	[
		# NIXOS
		nh
		comma
# 		nix-alien
		steam-run
		devenv
		nix-index
		nix-diff
		manix
		nix-inspect
		nix-search-cli
		nix-search-tv
		nix-output-monitor
		tclPackages.tix
		nixd
		nixfmt
		nix-tree
		nvd
	];
}
