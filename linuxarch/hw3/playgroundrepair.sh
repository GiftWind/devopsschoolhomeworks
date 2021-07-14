#!/usr/bin/bash
chown ftp-admin:ftp-admin ./playground/ftp
chmod 2775 ./playground/ftp
for d in ./playground/ftp/*/; do
	name=`echo $d | cut -d/ -f4`
	chown -R $name:ftp-admin ./playground/ftp/$name
	for element in `find ./playground/ftp/$name`; do
		if [ -d $element ]; then
			chmod 2775 $element;
		else
			chmod 664 $element;
		fi
	done
#	chmod 2770 -R ./playground/ftp/$name
done
