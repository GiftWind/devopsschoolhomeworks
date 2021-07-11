#!/bin/bash
comm <(cut -d: -f7 /etc/passwd | sort | uniq) <(tail -n+2 /etc/shells | sort)
