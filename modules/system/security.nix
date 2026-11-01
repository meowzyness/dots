{ ... }:
{
	security.polkit = {
		enable = true;
		enablePkexecWrapper = true;
		adminIdentities = [ "unix-group:wheel" ];
	};

	security.doas.enable = true;
	security.doas.extraRules = [
		{
			users = [ "meowzy" ];
			noPass = true;
			keepEnv = true;
		}
	];
}
