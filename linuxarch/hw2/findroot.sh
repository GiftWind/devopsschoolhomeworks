#!/bin/bash
find / -type f 2>/dev/null | grep root | grep -v proc | wc -l 
