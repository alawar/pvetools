#!/bin/bash

if [ ! -f `dirname $0`/pvetools.conf ]; then
	if [ -f /usr/local/etc/pvetools/pvetools.conf ]; then
		. /usr/local/etc/pvetools/pvetools.conf
		cp -f /usr/local/etc/pvetools/pvetools.conf `dirname $0`/pvetools.conf
	else
		touch `dirname $0`/pvetools.conf
	fi
fi


NODES=`cat /etc/pve/.members | awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/ip/){print $(i+1)}}}' | xargs echo`

cd `dirname $0`

SRC_DIR=`pwd`

for i in $NODES; do
	echo "Node $i"
	TEMP_DIR=`ssh $i mktemp -d --suffix _pve`
	if [ "$TEMP_DIR" ]; then
		rsync -a --delete --exclude '.git' $SRC_DIR/ $i:$TEMP_DIR
		if [ "$DIR_TO_SYNC" ]; then
			if [ -d $DIR_TO_SYNC ]; then
				ssh $i mkdir -p $DIR_TO_SYNC
				rsync -a --delete $DIR_TO_SYNC/ $i:$DIR_TO_SYNC
			else
				echo "Directory $DIR_TO_SYNC is not exists!"
			fi
		fi
		ssh $i $TEMP_DIR/install.sh
		ssh $i rm -rf $TEMP_DIR
	else
		echo "Cannot create temp dir!"
	fi
done

rm -f `dirname $0`/pvetools.conf

