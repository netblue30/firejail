# Firejail profile for bsdtar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bsdtar.local
# Persistent global definitions
include globals.local

ignore include disable-devel.inc
ignore include disable-shell.inc
include archiver-common.inc

# support compressed archives
private-bin bash,bsdcat,bsdcpio,bsdtar,bzip2,compress,gtar,gzip,lbzip2,libarchive,lz4,lzip,lzma,lzop,sh,xz
private-etc alternatives,group,localtime,passwd
