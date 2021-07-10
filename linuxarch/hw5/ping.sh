#!/usr/bin/bash
if ping -c 1 "$1" >& /dev/null; then
	echo "$1 is alive"
else
	echo "$1 is not alive"
fi
