#!/bin/bash

if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
	cp -f /usr/local/etc/pvetools/pvetools.conf `dirname $0`/pvetools.conf
else
	touch `dirname $0`/pvetools.conf
fi

. `dirname $0`/pvetools.conf.default

if [ -f $HOST_CONFIG_DIR/pvetools.conf.default ]; then
	echo "already installed"
	exit 0
fi

echo "installing..."
mkdir -p $HOST_CONFIG_DIR
cp `dirname $0`/pvetools.conf.default $HOST_CONFIG_DIR
if [ ! -L /usr/local/etc/pvetools ]; then
	ln -s $HOST_CONFIG_DIR /usr/local/etc/pvetools
fi

cp -f `dirname $0`/pvetools.conf $HOST_CONFIG_DIR/pvetools.conf

mkdir -p $HOST_INSTALL_DIR

rsync -a $PREFIX/bin $HOST_INSTALL_DIR

cat $PREFIX/distr/vz.vps | sed "s|<HOST_BIN>|$HOST_INSTALL_DIR\/bin|g" > /etc/vz/conf/vps.mount
cp /etc/vz/conf/vps.mount /etc/vz/conf/vps.umount

ln -s $HOST_INSTALL_DIR/bin/start_all_vms.sh /usr/local/bin/${APP_PREFIX}start_all_vms.sh
ln -s $HOST_INSTALL_DIR/bin/stop_all_vms.sh /usr/local/bin/${APP_PREFIX}stop_all_vms.sh

rm -f `dirname $0`/pvetools.conf
