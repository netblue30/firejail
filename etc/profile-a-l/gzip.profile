# Firejail profile for gzip
# Description: GNU compression utilities
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gzip.local
# Persistent global definitions
include globals.local

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

include archiver-common.inc

private-bin gunzip,gzexe,gzip,uncompress,zcat,zcmp,zdiff,zegrep,zfgrep,zforce,zgrep,zless,zmore,znew
