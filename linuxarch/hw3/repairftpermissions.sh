#!/usr/bin/bash
chown ftp-admin:ftp-admin /var/ftp
chmod 2775 /var/ftp
for d in /var/ftp/*/; do
	name=`echo $d | cut -d/ -f4`
	chown -R $name:ftp-admin /var/ftp/$name
	chmod 2770 -R /var/ftp/$name
done
