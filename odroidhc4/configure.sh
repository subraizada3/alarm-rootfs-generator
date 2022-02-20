#!/usr/bin/env sh

if [ $(id -u) -ne 0 ]; then
	echo "This script needs to be run as root"
	exit 1
fi

if [ $# -ne 4 ]; then
	echo "Args: rootfs dir, username, hostname, sshpubkey"
	echo "Example:"
	echo "    ./configure.sh rootfs bob computer /home/me/.ssh/id_ed25519.pub"
	exit 1
fi

if [ ! -d $ROOTFS_DIR ]; then
	echo "rootfs dir does not exist"
	exit 1
fi



SCRIPT_DIR=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

echo "#!/usr/bin/env sh" >${1}/configure2.sh
echo USER=$2 >>${1}/configure2.sh
echo HOSTNAME=$3 >>${1}/configure2.sh
cat ${SCRIPT_DIR}/_configure.sh >>${1}/configure2.sh
chmod +x ${1}/configure2.sh

cp ${SCRIPT_DIR}/linux-aarch64-5.15.5-1-aarch64.pkg.tar.xz ${1}/linux-aarch64-5.15.5-1-aarch64.pkg.tar.xz
