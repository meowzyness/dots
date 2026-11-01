{ pkgs, ... }:
{
	boot.loader.systemd-boot.memtest86.enable = true;

	boot.supportedFilesystems = [ "ntfs" "exfat" "xfs" "f2fs" ];

	services.udisks2.enable = true;

	environment.systemPackages = with pkgs; [
		# DISKS
		parted
		gptfdisk
		gparted
		cryptsetup
		lvm2
		mdadm
		smartmontools
		nvme-cli
		hdparm

		# LOST DATA
		testdisk
		ddrescue
		partclone
		fsarchiver

		# BOOT
		efibootmgr
		efivar
		sbctl
		os-prober

		# WINDOWS
		chntpw
		wimlib

		# HARDWARE
		pciutils
		usbutils
		lshw
		dmidecode
		inxi
		lm_sensors
		memtester
		stress-ng

		# NETWORK
		nmap
		iperf3
		mtr
		tcpdump
		dig
		curl
		wget
		rsync
		rclone
		sshfs
		cifs-utils
		nfs-utils
		ethtool
		iw

		# GENERAL
		git
		htop
		btop
		ncdu
		file
		pv
		p7zip
		zstd
		lsof
		strace
		tree
	];
}
