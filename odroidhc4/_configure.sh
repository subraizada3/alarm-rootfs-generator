#!/usr/bin/env sh


cat <<EOF >>/etc/fstab
/dev/mmcblk0p2 / ext4 rw,relatime 0 1
/dev/mmcblk0p1 /boot vfat rw,relatime 0 2
EOF



pacman -S --noconfirm --needed \
  smartmontools hdparm hddtemp



# fancontrol config modified from https://www.armbian.com/odroid-hc4/
cat >/etc/fancontrol <<EOF
INTERVAL=10
DEVPATH=hwmon0=devices/virtual/thermal/thermal_zone0 hwmon2=devices/platform/pwm-fan
DEVNAME=hwmon0=cpu_thermal hwmon2=pwmfan
FCTEMPS=hwmon2/pwm1=hwmon0/temp1_input
FCFANS=hwmon2/pwm1=hwmon2/pwm1
# To always run the fan at full speed, change MINTEMP/MAXTEMP from 50/60 to 1/2
MINTEMP=hwmon2/pwm1=50
MAXTEMP=hwmon2/pwm1=60
MINSTART=hwmon2/pwm1=40
MINSTOP=hwmon2/pwm1=40
MINPWM=hwmon2/pwm1=40
MAXPWM=hwmon2/pwm1=255
EOF

systemctl enable fancontrol.service

# disable kernel's automatic fan control based on cpu/ram temperature
echo "echo disabled | tee /sys/devices/virtual/thermal/thermal_zone*/mode" >>/startup.sh





cat >/boot/boot.ini <<EOF
ODROIDC4-UBOOT-CONFIG

setenv bootargs "root=/dev/mmcblk0p2 rootwait rw console=ttyAML0,115200n8 console=tty1 no_console_suspend fsck.repair=yes \${amlogic}"

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
