{ ... }:
{
	services.tailscale.enable = true;
	networking.networkmanager.enable = true;
	systemd.network.wait-online.enable = false;
	services.resolved.enable = true;
	boot.kernelModules = [ "tun" ];

	programs.clash-verge = {
		enable = true;
		serviceMode = true;
		tunMode = true;
	};

	networking.firewall = {
		enable = true;
		checkReversePath = false;
		trustedInterfaces = [ "Mihomo" ];
		extraReversePathFilterRules = ''
			iifname { "Mihomo" } accept comment "trusted interface"
		'';
	};
}
