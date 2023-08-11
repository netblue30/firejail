#!/bin/sh
# See ../../../src/firecfg/firecfg.config

sed -E -e '/^#$/d' -e '/^# /d' -e 's/^#([^ ])/\1/' "$1" |
LC_ALL=C sort -c -u
