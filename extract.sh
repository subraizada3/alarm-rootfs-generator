#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]; then
	echo "This script needs to be run as root"
	exit 1
fi

if [ $(ps -o comm= -p $(ps -o ppid= -p $$)) = "sudo" ]; then
	echo "This script needs to be run as real root, not with sudo"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Incorrect args: pass dir to extract rootfs to as first arg"
	echo "Example:"
	echo "    ./extract.sh rootfs"
	exit 1
fi

mkdir -p $1

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C $1

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
