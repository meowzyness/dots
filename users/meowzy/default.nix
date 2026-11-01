{ pkgs, ... }:
{
	users.users.meowzy = {
		isNormalUser = true;
		description = "such a silly guy";
		extraGroups = [ "surface-control" "networkmanager" "wheel" "audio" "input" ];
		shell = pkgs.fish;
	};

	home-manager.users.meowzy = { ... }:
	{
		home.username = "meowzy";
		home.homeDirectory = "/home/meowzy";
		home.stateVersion = "24.11";
		home.sessionPath = [ "$HOME/config/scripts" ];

		imports = [
			../../modules/home
		];
	};
}
