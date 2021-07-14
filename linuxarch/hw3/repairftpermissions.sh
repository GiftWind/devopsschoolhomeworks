#!/usr/bin/bash
chown ftp-admin:ftp-admin /var/ftp
chmod 2775 /var/ftp
for d in /var/ftp/*/; do
	name=`echo $d | cut -d/ -f4`
	chown -R $name:ftp-admin /var/ftp/$name
	for element in `find /var/ftp/$name`; do
		if [ -d $element ]; then
			chmod 2775 $element;
		else
			chmod  664 $element;
		fi
	done
#	chmod 2770 -R /var/ftp/$name
done
