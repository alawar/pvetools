#!/bin/bash

if [ -f  /usr/local/etc/pvetools/pvetools.conf.default ]; then
	. `dirname $0`/uninstall.sh
fi

if [ ! -f `dirname $0`/pvetools.conf ]; then
	if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
		cp -f /usr/local/etc/pvetools/pvetools.conf `dirname $0`/pvetools.conf
	else
		touch `dirname $0`/pvetools.conf
	fi
fi

echo "installing..."

. `dirname $0`/pvetools.conf.default

if [ -f $HOST_CONFIG_DIR/pvetools.conf.default ]; then
	echo "already installed"
	exit 0
fi

mkdir -p $HOST_CONFIG_DIR
cp `dirname $0`/pvetools.conf.default $HOST_CONFIG_DIR
if [ ! -L /usr/local/etc/pvetools ]; then
	ln -s $HOST_CONFIG_DIR /usr/local/etc/pvetools
fi

cp -f `dirname $0`/pvetools.conf $HOST_CONFIG_DIR/pvetools.conf

mkdir -p $HOST_INSTALL_DIR

rsync -a $PREFIX/bin $HOST_INSTALL_DIR

mkdir -p $HOST_INSTALL_DIR/data

cat $PREFIX/distr/vz.vps | sed "s|<HOST_BIN>|$HOST_INSTALL_DIR\/bin|g" > $HOST_INSTALL_DIR/data/vps.mount
md5sum $HOST_INSTALL_DIR/data/vps.mount | awk '{print $1'} > $HOST_INSTALL_DIR/data/vps.mount.md5

if [ ! -f /etc/vz/conf/vps.mount ]; then
	if [ ! -f /etc/vz/conf/vps.umount ]; then
		cp -f $HOST_INSTALL_DIR/data/vps.mount /etc/vz/conf/vps.mount
		cp -f $HOST_INSTALL_DIR/data/vps.mount /etc/vz/conf/vps.umount
	else
		echo "/etc/vz/conf/vps.umount already exists. Skipping..."
	fi
else
	echo "/etc/vz/conf/vps.mount already exists. Skipping..."
fi

for i in $HOST_INSTALL_DIR/bin/pve_*; do
	LINKNAME=`basename $i | sed "s/pve_/${APP_PREFIX}/g"`
	ln -s $i /usr/local/bin/$LINKNAME
done

rm -f `dirname $0`/pvetools.conf
