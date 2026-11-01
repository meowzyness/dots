{ ... }:
{
	nix = {
		distributedBuilds = true;
		settings.builders-use-substitutes = true;
		buildMachines = [
			{
				hostName = "labrat";
				system = "x86_64-linux";
				sshUser = "tonic";
				sshKey = "/root/.ssh/id_ed25519";
				maxJobs = 8;
				speedFactor = 2;
				supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
			}
		];
	};
}
