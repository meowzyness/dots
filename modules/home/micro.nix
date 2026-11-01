{ ... }:
{
	programs.micro = {
		enable = true;
		settings = {
			autosu = true;
			sucmd = "doas";
		};
	};
}
