#!/bin/bash
if [ -d "/data/cache/cache" ]; then
	echo "Running fast permissions check"
	ls -l /data/cache/cache | tail --lines=+2 | grep -v $(whoami) > /dev/null

	if [[ $? -eq 0 ]]; then
		echo "Fast permissions check failed"
		exit 1
	else
		echo "Fast permissions check successful, if you have any permissions error check for unwritable files in /data/cache/cache"
	fi

fi
