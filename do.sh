#!/bin/sh

if [ $# -ne 6 ]; then
	echo "Incorrect args. Should be:"
	echo "    board name,   target device,   mountpoint,   username,   hostname,   sshpubkey"
	echo
	echo "board name can be 'none'"
	echo "target device is the SD card or other block device to flash"
	echo "mountpoint should be an empty directory, used to mount the target device for flashing"
	echo "username is the name of the non-root user to create in the rootfs"
	echo "hostname is the hostname to use in the rootfs"
	echo "sshpubkey is your public key to copy to the rootfs's root and non-root user"
	echo
	echo "Example:"
	echo "    ./do.sh odroidhc4 /dev/sda /mnt/sd username hostname /home/me/.ssh/id_ed25519.pub"
	exit 1
fi

BOARD=$1
DEV=$2
MP=$3
username=$4
hostname=$5
sshkey=$6



umount -q rootfs-$BOARD

rm -rf rootfs-$BOARD
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

./extract.sh rootfs-$BOARD
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

mount --bind rootfs-$BOARD rootfs-$BOARD
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi


./configure.sh rootfs-$BOARD $username $hostname $sshkey
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
if [ -f ${BOARD}/configure.sh ]; then
	${BOARD}/configure.sh rootfs-$BOARD $username $hostname $sshkey
	rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
fi

echo
echo
echo
echo "Entering chroot..."
echo "Run this command inside the chroot:"
echo "    ./configure.sh && exit"
echo
echo "You will then be asked to enter a password"
echo
sudo arch-chroot rootfs-$BOARD


umount rootfs-$BOARD
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

# in case it's already mounted for some reason
./unmount.sh $DEV
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

./flash.sh rootfs-$BOARD $DEV $MP
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
if [ -f ${BOARD}/flash.sh ]; then
	${BOARD}/flash.sh rootfs-$BOARD $DEV $MP
	rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
fi

./unmount.sh $DEV
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
