#!/usr/bin/env sh

SCRIPT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

if [ $# -ne 3 ]; then
	echo "Args: rootfs dir, target device, mountpoint"
	echo "Example:"
	echo "    ./flash.sh rootfs /dev/sda /mnt/x"
	exit 1
fi

if [ ! -b $2 ]; then
	echo "target is not a block device"
	exit 1
fi

dd if=${SCRIPT_DIR}/u-boot-sunxi-with-spl.bin of=$2 conv=fsync,notrunc bs=8k seek=1
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

sync
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
