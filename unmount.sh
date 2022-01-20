#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]; then
	echo "This script needs to be run as root"
	exit 1
fi

if [ $# -ne 1 ]; then
	echo "Args: target device"
	echo "Example:"
	echo "    ./unmount.sh /dev/sda"
	exit 1
fi

umount -q ${1}1
#rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
umount -q ${1}2
#rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
sync
#rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
sync
#rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
