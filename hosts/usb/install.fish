#!/usr/bin/env fish

function die
	printf '%s\n' $argv >&2
	exit 1
end

if not set -q argv[1]
	die "Usage: "(status filename)" /dev/sdX"
end

set dev $argv[1]

if test (id -u) -eq 0
	die "dont run as root"
end

if not test -b "$dev"
	die "$dev is not a disk"
end

set dev (readlink -f "$dev"); or die "couldnt resolve $dev"

if test (lsblk -dno TYPE "$dev") != disk
	die "$dev is not a disk"
end

set tran (lsblk -dno TRAN "$dev")
if test "$tran" != usb
	set tran_label "$tran"
	if test -z "$tran_label"
		set tran_label unknown
	end
		die "$dev is not a USB disk"
end

set mounted (lsblk -no MOUNTPOINTS "$dev" | tr -d '[:space:]')
if test -n "$mounted"
	die "$dev has mounted partitions"
end

set script_dir (dirname (status filename))

read --prompt-str="where your nixos config at (with flake.nix and stuff)?  " dots

set src (nix flake metadata --json "$dots" | jq -er .path); or die "couldnt get flake path"

lsblk -o NAME,SIZE,MODEL,LABEL "$dev"
read --prompt-str="$dev will be erased, type ERASE to continue: " answer

if test "$answer" != ERASE
	die "cancelled"
end

# Installation:
doas nix run --inputs-from "path:$src" disko#disko-install -- --flake "path:$src#usb" --disk usb "$dev"
