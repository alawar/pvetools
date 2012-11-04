#!/bin/bash

. `dirname $0`/pvetools.conf.default

rm -f /usr/local/etc/pvetools
rm -rf $HOST_CONFIG_DIR
rm -rf $HOST_INSTALL_DIR
rm -f /etc/vz/conf/vps.mount
rm -f /etc/vz/conf/vps.umount

find /usr/local/bin -type l |
while read test
do
	if [ "`readlink $test | grep $HOST_INSTALL_DIR`" ]; then
		rm -f $test
	fi
done

