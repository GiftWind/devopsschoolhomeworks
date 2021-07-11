#!/usr/bin/bash
comm <(cut -d: -f7 /etc/passwd | sort | uniq) <(grep -v '\#' /etc/shells | sort)
