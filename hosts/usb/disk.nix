{ ... }:
{
	disko.devices.disk.usb = {
		type = "disk";

		device = "/dev/disk/by-id/set-by-install-sh";
		content = {
			type = "gpt";
			partitions = {
				ESP = {
					size = "1G";
					type = "EF00";
					content = {
						type = "filesystem";
						format = "vfat";
						mountpoint = "/boot";
						mountOptions = [ "umask=0077" ];
					};
				};
				root = {
					size = "100%";
					content = {
						type = "btrfs";
						extraArgs = [ "-f" ];
						subvolumes = {
							"/root" = { mountpoint = "/";     mountOptions = [ "compress=zstd" "noatime" ]; };
							"/home" = { mountpoint = "/home"; mountOptions = [ "compress=zstd" "noatime" ]; };
							"/nix"  = { mountpoint = "/nix";  mountOptions = [ "compress=zstd" "noatime" ]; };

							"/persist" = { mountpoint = "/persist"; mountOptions = [ "compress=zstd" "noatime" ]; };
						};
					};
				};
			};
		};
	};
}
