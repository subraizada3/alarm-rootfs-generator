#!/usr/bin/env sh

echo "Enter password to set for users: root, $USER"
echo "Warning: typed password will be visible on terminal"
read password
userdel -r alarm
useradd -m -g wheel $USER
echo "root:$password" | chpasswd
echo "$USER:$password" | chpasswd



ln -sf /usr/share/zoneinfo/America/Denver /etc/localtime

sed -ie 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 >/etc/locale.conf



echo $HOSTNAME >/etc/hostname
cat <<EOF >>/etc/hosts
127.0.0.1 localhost
::1 localhost
127.0.1.1 $HOSTNAME
EOF



sed -ie 's/#Color$/Color/' /etc/pacman.conf

pacman-key --init
pacman-key --populate archlinuxarm
pacman -Syu --noconfirm


pacman -S --noconfirm --needed \
  base-devel bash-completion man man-pages \
  vim htop pv tree ncdu colordiff iotop \
  curl wget git rsync \
  net-tools traceroute bind usbutils pciutils \
  zip unzip unrar gzip bzip2 p7zip \
  ntfs-3g exfat-utils \
  python python-pip \
  sudo ufw cronie \
  lm_sensors

systemctl enable cronie ufw



sed -ie 's/#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config



echo "%wheel ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers



mkdir -p /root/.ssh
chmod 700 /root/.ssh
mkdir -p /home/${USER}/.ssh
chmod 700 /home/${USER}/.ssh
cat /id_*.pub >/root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
cat /id_*.pub >/home/${USER}/.ssh/authorized_keys
chmod 600 /home/${USER}/.ssh/authorized_keys
chown -R ${USER}:wheel /home/${USER}/.ssh
rm /id_*.pub



mkdir log2ram
tar --strip-components=1 -xvzf log2ram-*.tar.gz -C log2ram
cd log2ram
sed -ie 's/^.*systemctl .*is-active.*$//' install.sh
sed -ie 's/if \[ -d \/etc\/logrotate.d.*$/if \[ true \]\; then\nmkdir -p \/etc\/logrotate.d/' install.sh
./install.sh
cd ..
rm -rf log2ram*

sed -ie 's/#SystemMaxUse.*/SystemMaxUse=20M/' /etc/systemd/journald.conf



cat <<EOF >/etc/bash.bashrc
. /usr/share/bash-completion/bash_completion

shopt -s checkwinsize # resize with terminal window
shopt -s globstar # ** for recursive
shopt -s extglob # !(*.xml) for inverse of *.xml

shopt -s histappend
export HISTCONTROL="ignoredups:ignorespace"
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%Y-%m-%d %T " # show timestamps in 'history' command
export PROMPT_COMMAND='history -a'   # append to history after each command instead of on logout

export EDITOR=vim
tabs 2

PS1='[\u@\h \W]\\$ '
alias ls='ls --color=auto'
EOF



# https://askubuntu.com/a/1327781
cat <<EOF >/etc/systemd/system/startupsh.service
[Unit]
Description=startup.sh
[Service]
Type=simple
ExecStart=/startup.sh
[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/startup.sh
#!/bin/sh

EOF

chmod +x startup.sh
systemctl enable startupsh.service



# https://askubuntu.com/a/1327781
cat <<EOF >/etc/systemd/system/firstboot.service
[Unit]
Description=One time boot script
[Service]
Type=simple
ExecStart=/firstboot.sh
[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/firstboot.sh
#!/bin/sh

ufw default deny
ufw allow from 192.168.0.0/16
ufw limit ssh
ufw enable

systemctl disable firstboot.service
rm -rf /etc/systemd/system/firstboot.service
rm -f /firstboot.sh
EOF

chmod +x firstboot.sh
systemctl enable firstboot.service



if [ -f /configure2.sh ]; then
	/configure2.sh
	rv=$?
	rm /configure2.sh
	if [ $rv -ne 0 ]; then exit $rv; fi
fi



rm $0
