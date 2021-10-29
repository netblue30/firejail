#!/bin/sh
tail -n +4 "$1" | sed 's/^# /#/' | LC_ALL=C sort -c -d
