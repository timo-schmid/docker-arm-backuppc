#!/bin/bash

if [ ! -e /var/lib/backuppc/cpool ]
then
	mkdir /var/lib/backuppc/cpool
	mkdir /var/lib/backuppc/pc
	chown backuppc:backuppc /var/lib/backuppc
fi

exec /usr/local/bin/supervisord -c /etc/supervisord.conf

