{ config, lib, utils, inputs, ... }:
let
	cfg = config.dots.impermanence;
in
{
	imports = [ inputs.impermanence.nixosModules.impermanence ];

	options.dots.impermanence = {
		enable = lib.mkEnableOption "keeping only the whitelisted system state across reboots";
		home.enable = lib.mkEnableOption "keeping only the whitelisted home folders across reboots";

		rollback = {
			device = lib.mkOption {
				type = lib.types.str;
				example = "/dev/disk/by-partlabel/disk-usb-root";
				description = "btrfs partition that holds the root subvolume";
			};
			subvolume = lib.mkOption { type = lib.types.str; default = "root"; };
		};
	};

	config = lib.mkIf config.dots.impermanence.enable {
		environment.persistence."/persist" = {
			hideMounts = true;

			files = [
				"/etc/machine-id"
				"/etc/adjtime"
			];

			directories = [
				"/etc/NetworkManager/system-connections" # Wi-Fi passwords
				"/var/lib/nixos" # user and group ids
				"/var/lib/systemd" # timers, random seed, backlight
				"/var/log"
				"/var/lib/bluetooth" # paired devices
				"/var/lib/NetworkManager"
				"/var/lib/tailscale" # login
				"/var/lib/clash-verge-service"
				"/var/lib/upower"
				"/var/lib/power-profiles-daemon"
				"/var/lib/chrony"
				{ directory = "/root/.ssh"; mode = "0700"; } # remote build key
			] ++ lib.optional config.virtualisation.docker.enable "/var/lib/docker";

			users.meowzy = lib.mkIf config.dots.impermanence.home.enable {
				directories = [
					"files"
					"dots"
					{ directory = ".ssh"; mode = "0700"; }
				];
			};
		};

		# sshd creates its host keys before any bind mount exists, so they are in /persist directly; agenix decrypts secrets with the same key
		services.openssh.hostKeys = [
			{ path = "/persist/etc/ssh/ssh_host_ed25519_key"; type = "ed25519"; }
			{ path = "/persist/etc/ssh/ssh_host_rsa_key"; type = "rsa"; bits = 4096; }
		];
		age.identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];

		fileSystems."/persist".neededForBoot = true;

		boot.initrd.systemd.services.rollback-root = let
			device = cfg.rollback.device;
			unit = "${utils.escapeSystemdPath device}.device";
		in {
			description = "replaces the root subvolume with an empty one";
			wantedBy = [ "initrd.target" ];
			requires = [ unit ];
			after = [ unit ];
			before = [ "sysroot.mount" ];
			unitConfig.DefaultDependencies = "no";
			serviceConfig.Type = "oneshot";
			script = ''
				mkdir -p /btrfs
				mount -t btrfs -o subvol=/ ${device} /btrfs
				root=/btrfs/${cfg.rollback.subvolume}
				if [ -e "$root" ]; then
					mkdir -p /btrfs/old_roots
					mv "$root" "/btrfs/old_roots/$(date +%Y-%m-%d_%H:%M:%S)"
				fi

				# Delete old roots after a week, nested subvolumes first
				delete() {
					btrfs subvolume list -o "$1" | cut -f 9- -d ' ' | while read -r sub; do
						delete "/btrfs/$sub"
					done
					btrfs subvolume delete "$1"
				}
				now=$(date +%s)
				for old in /btrfs/old_roots/*; do
					[ -e "$old" ] || continue
					if [ $(( now - $(stat -c %Y "$old") )) -gt 604800 ]; then
						delete "$old"
					fi
				done

				btrfs subvolume create "$root"
				umount /btrfs
			'';
		};
	};
}
