#!/bin/bash

if [ ! -f `dirname $0`/pvetools.conf ]; then
	if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
		cp -f /usr/local/etc/pvetools/pvetools.conf `dirname $0`/pvetools.conf
	else
		touch `dirname $0`/pvetools.conf
	fi
fi

echo "uninstalling..."

. `dirname $0`/pvetools.conf.default

rm -f /usr/local/etc/pvetools/pvetools.conf.default

if [ -f $HOST_INSTALL_DIR/data/vps.mount.md5 ]; then
	TMP_MD52=`cat $HOST_INSTALL_DIR/data/vps.mount.md5`
fi

if [ -f /etc/vz/conf/vps.mount ]; then
	TMP_MD51=`md5sum /etc/vz/conf/vps.mount | awk '{print $1}'`

	if [ "$TMP_MD51" = "$TMP_MD52" ]; then
		rm -f /etc/vz/conf/vps.mount
	else
		echo "/etc/vz/conf/vps.mount is not owned by pvetools. Skipping..."
	fi
fi

if [ -f /etc/vz/conf/vps.umount ]; then
	TMP_MD51=`md5sum /etc/vz/conf/vps.umount | awk '{print $1}'`

	if [ "$TMP_MD51" = "$TMP_MD52" ]; then
		rm -f /etc/vz/conf/vps.umount
	else
		echo "/etc/vz/conf/vps.umount is not owned by pvetools. Skipping..."
	fi
fi

rm -rf $HOST_INSTALL_DIR/bin
rm -rf $HOST_INSTALL_DIR/data

find /usr/local/bin/ -type l |
while read test
do
	if [ "`readlink $test | grep $HOST_INSTALL_DIR`" ]; then
		rm -f $test
	fi
done

if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
	cp -f `dirname $0`/pvetools.conf /usr/local/etc/pvetools/pvetools.conf
fi

rm -f `dirname $0`/pvetools.conf
