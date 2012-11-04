#!/bin/bash

. `dirname $0`/pvetools.conf.default

if [ ! -f $HOST_CONFIG_DIR/pvetools.conf.default ]; then
	. `dirname $0`/install.sh
fi

