#!/bin/bash

. `dirname $0`/pvetools.conf.default

if [ -f $HOST_CONFIG_DIR/pvetools.conf.default ]; then
	echo "already installed"
	exit 0
fi

echo "installing..."
mkdir -p $HOST_CONFIG_DIR
cp `dirname $0`/pvetools.conf.default $HOST_CONFIG_DIR
ln -s $HOST_CONFIG_DIR /usr/local/etc/pvetools

touch $HOST_CONFIG_DIR/pvetools.conf

mkdir -p $HOST_INSTALL_DIR

mkdir -p $HOST_INSTALL_DIR/bin
cp -r $PREFIX/bin/vps.* $HOST_INSTALL_DIR/bin

cat $PREFIX/bin/vz.vps | sed "s|<HOST_BIN>|$HOST_INSTALL_DIR\/bin|g" > /etc/vz/conf/vps.mount
cp /etc/vz/conf/vps.mount /etc/vz/conf/vps.umount
