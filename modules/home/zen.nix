{ inputs, ... }:
{
	imports = [
		inputs.zen-browser.homeModules.beta
	];

	programs.zen-browser = {
		enable = true;

		profiles.meowzy =  {
			id = 0;
			name = "Meowzy";
			isDefault = true;
		};
	};
}
