#!/usr/bin/bash
ping -c 1 -w 2 "$1" >& /dev/null;
if [ $? -eq 0 ]
then
	echo "$1 is alive"
else
	echo "$1 is not alive"
fi
