# Rootfs configurator/generator for Arch Linux ARM

This collection of scripts can prepare an Arch Linux ARM (ALARM) rootfs, then optionally also apply some board-specific tweaks and flash to an SD card.

The following boards are currently supported:
- Odroid HC4
- Pine H64 - currently in development - U-Boot is not working

However, the rootfs preparation part is completely hardware-agnostic and uses the official generic AArch64 ALARM rootfs as a base.

# Usage

Download `ArchLinuxARM-aarch64-latest.tar.gz` from https://archlinuxarm.org/platforms/armv8/generic. Then:

```
sudo su
./do.sh
```

### What does `do.sh` do?

- delete any existing previously-generated rootfs for this board (the board can be specified as 'none' to generate a generic rootfs)
- run `extract.sh`: extracts `ArchLinuxARM-aarch64-latest.tar.gz` to `rootfs-$BOARD`
- bind mount the rootfs folder onto itself, to prepare for `arch-chroot`
- run `configure.sh` and, if it exists, `$BOARD/configure.sh`: copy into the extracted rootfs the rootfs configuration scripts, also copy SSH key into the rootfs
- `arch-chroot` into the rootfs and run the configuration script
	- This is the only point where manual intervention is required, you will need to run one command inside the chroot and then enter a password for the generated system
- unmount the rootfs folder

At this point, if you've been running the individual steps manually, you can tar up the rootfs folder to save a copy of your generated rootfs. However, the `do.sh` script will continue with the following steps:

- run `flash.sh`: partition the SD card and flash the filesystem onto it
- run, if it exists, `$BOARD/flash.sh`: do things like install the bootloader onto the SD card and generate files for U-Boot
- sync and unmount the SD card

At this point you can put the SD card into your board and start using your system.

### How is the generic ALARM rootfs modified?

The aim of this project is to generate a minimal, unbloated, but usable ALARM system for various single board computers.

The configuration script does the following things:
- set up locale, timezone, fstab, hostname
- initialize pacman and do a system update
- install basic packages such as `base-devel man vim ncdu git rsync python cronie zip`
- configure sudo (set up sudoers, allow passwordlesssudo ), ssh (install public keys), ufw (default deny, allow all from LAN, limit SSH)
- install [log2ram](https://github.com/azlux/log2ram) to reduce SD card wear
- systemctl enable services like sshd, cronie, ufw, log2ram
- delete the default `alarm` user and set up a new user with the username/password that you want
- install a bashrc
- create an (empty by default) `/startup.sh` which runs on boot

You will want to change the locale, timezone, and bashrc parts of `_configure.sh` to suit your preferences, and also have it install any other packages you want to have in the base system. The provided `_configuration.sh` is not supposed to be a 'one thing fits all' solution.

The board-specific configuration scripts do things like set up files that U-Boot needs, and add board-specific configuration to `startup.sh`. These should not need to be modified.
