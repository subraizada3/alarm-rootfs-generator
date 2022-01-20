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

ROOTFS=$1
USERNAME=$2
HOSTNAME=$3
SSHKEY=$4

echo "#!/usr/bin/env sh" >${ROOTFS}/configure.sh
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo USER=$USERNAME >>${ROOTFS}/configure.sh
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

echo HOSTNAME=$HOSTNAME >>${ROOTFS}/configure.sh
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

cat _configure.sh >>${ROOTFS}/configure.sh
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

chmod +x ${ROOTFS}/configure.sh
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

cp log2ram-*.tar.gz ${ROOTFS}/
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi

cp $SSHKEY ${ROOTFS}/
rv=$?; if [ $rv -ne 0 ]; then exit $rv; fi
