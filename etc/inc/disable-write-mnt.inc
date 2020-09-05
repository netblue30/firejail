# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-write-mnt.local

read-only /mnt
read-only /media
read-only /run/mount
read-only /run/media
