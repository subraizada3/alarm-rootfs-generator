#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]; then
	echo "This script needs to be run as root"
	exit 1
fi

if [ $# -ne 3 ]; then
	echo "Args: rootfs dir, target device, mountpoint"
	echo "Example:"
	echo "    ./flash.sh rootfs /dev/sda /mnt/x"
	exit 1
fi

ROOTFS_DIR=$1
DEV=$2
MP=$3

if [ ! -b $DEV ]; then
	echo "target is not a block device"
	exit 1
fi

if [ ! -d $MP ]; then
	echo "mountpoint does not exist"
	exit 1
fi

if [ ! -z "$(ls -A $MP)" ]; then
	echo "mountpoint is not empty"
	exit 1
fi

if [ ! -d $ROOTFS_DIR ]; then
	echo "rootfs dir does not exist"
	exit 1
fi

fdisk -W always $DEV <<EOF
o
n
p
1
2048
+256M
t
0c
n
p
2


w
EOF

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

mkfs.fat -F32 ${DEV}1
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
mkfs.ext4 -F ${DEV}2
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo "device prepared"

mount ${DEV}2 $MP
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
mkdir -p ${MP}/boot
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
mount ${DEV}1 ${MP}/boot
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo "device mounted"
echo "copying data"

cp -a ${ROOTFS_DIR}/. $MP
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo "cp exited... syncing"

sync
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
sync
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo "data copied and synced"

tput bel
