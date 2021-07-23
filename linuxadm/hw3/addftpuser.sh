#!/bin/bash
if [ $USER != "root" ];then
	echo "You must be root to execute this script"
	exit 1
fi
username=$1
grep $username /etc/passwd > /dev/null
if [ $? -eq 0 ];then
	echo "User $username already exists"
       	exit 1
fi	
	useradd -m -s /bin/bash $username
	password=$(cat /dev/urandom | base64 | head -c 8)
	echo $username:$password | chpasswd
	passwd -e $username > /dev/null
	mkdir /var/ftp/$username
	chown $username /var/ftp/$username
	chmod 775 /var/ftp/$username
	echo "User $username was created with password $password"

