{
	description = "Meowzy's NixOS configuration";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

		# pinned so kernel wont rebuild every single f*cking update
		nixos-hardware.url = "github:NixOS/nixos-hardware/2e790b0a6be8ec2b76174ac0931b8ff11919ec98";
		nixpkgs-kernel.url = "github:nixos/nixpkgs/b6c98e9e6633ee64753b594ff4a5febf0367fc00";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		stylix = {
			url = "github:nix-community/stylix";
			inputs.nixpkgs.follows = "nixpkgs";
		};



		hyprland.url = "github:hyprwm/Hyprland"; # no nixpkgs.follows so it will download the cached version

		hyprgrass = {
			url = "github:horriblename/hyprgrass";
			inputs.hyprland.follows = "hyprland";
		};

		noctalia = {
			url = "github:noctalia-dev/noctalia-shell";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		disko = {
			url = "github:nix-community/disko/latest";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		impermanence = {
			url = "github:nix-community/impermanence";
			inputs.nixpkgs.follows = "nixpkgs";
			inputs.home-manager.follows = "home-manager";
		};

		agenix = {
			url = "github:ryantm/agenix";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		zen-browser = {
			url = "github:0xc000022070/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixcord.url = "github:4evy/nixcord";
	};

	outputs = { nixpkgs, home-manager, ... }@inputs:
	{
		nixosConfigurations =
		let
			mkHost = name: nixpkgs.lib.nixosSystem {
				specialArgs = { inherit inputs; };
				modules = [
					{ nixpkgs.hostPlatform = "x86_64-linux"; }
					inputs.stylix.nixosModules.stylix
					inputs.hyprland.nixosModules.default

					home-manager.nixosModules.home-manager
					{
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit inputs; };
					}

					./hosts/${name}
				];
			};
		in
		{
			surf   = mkHost "surf";
			labrat = mkHost "labrat";
			usb    = mkHost "usb";
		};
	};
}
