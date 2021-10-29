#!/bin/sh
tail -n +5 "$1" | LC_ALL=C sort -c -u
