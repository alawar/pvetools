#!/bin/bash

. `dirname $0`/pvetools.conf.default

rm -f /usr/local/etc/pvetools
rm -rf $HOST_CONFIG_DIR
rm -rf $HOST_INSTALL_DIR
rm -f /etc/vz/conf/vps.mount
rm -f /etc/vz/conf/vps.umount

. `dirname $0`/install.sh

