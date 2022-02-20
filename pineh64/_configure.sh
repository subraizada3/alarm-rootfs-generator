#!/usr/bin/env sh

cat <<EOF >>/etc/fstab
/dev/mmcblk2p2 / ext4 rw,relatime 0 1
/dev/mmcblk2p1 /boot vfat rw,relatime 0 2
EOF

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

mkdir -p /boot/extlinux
cat >/boot/extlinux/extlinux.conf <<EOF
LABEL ALARM
	KERNEL /Image
	FDT /dtbs/allwinner/sun50i-h6-pine-h64-model-b.dtb
	APPEND initrd=/initramfs-linux.img root=/dev/mmcblk2p2 rw rootwait console=ttyS0,115200 console=tty1
EOF

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
