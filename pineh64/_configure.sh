#!/usr/bin/env sh

cat >/boot/boot.ini <<EOF
setenv bootargs "root=/dev/mmcblk0p2 rootwait rw console=ttyS0,115200n8 console=tty1 no_console_suspend fsck.repair=yes

setenv dtb_loadaddr "0x20000000"
setenv initrd_loadaddr "0x4080000"
setenv loadaddr "0x1080000"

load mmc \${devno}:1 \${dtb_loadaddr} /dtbs/amlogic/meson-sm1-odroid-hc4.dtb
load mmc \${devno}:1 \${initrd_loadaddr} /initramfs-linux.uimg
load mmc \${devno}:1 \${loadaddr} /Image

booti \${loadaddr} \${initrd_loadaddr} \${dtb_loadaddr}
EOF

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi



pacman -S --noconfirm uboot-tools
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

mkimage -A arm64 -O linux -T ramdisk -d /boot/initramfs-linux.img /boot/initramfs-linux.uimg
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi



# from https://github.com/archdroid-org/pkgbuilds/blob/master/uboot-odroid-c4/91-uboot-uimg.hook
cat >/usr/share/libalpm/hooks/91-uboot-uimg.hook <<EOF
[Trigger]
Type = File
Operation = Install
Operation = Upgrade
Target = boot/Image
Target = usr/lib/initcpio/*

[Action]
Description = Regenerating uboot uimg...
When = PostTransaction
Exec = /usr/bin/mkimage -A arm64 -O linux -T ramdisk -d /boot/initramfs-linux.img /boot/initramfs-linux.uimg
EOF

rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
