# Firejail profile for bsdtar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include /etc/firejail/bsdtar.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

blacklist /tmp/.X11-unix

hostname bsdtar
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
# noroot
nosound
notv
novideo
nonewprivs
protocol unix
seccomp
shell none

tracelog

# support compressed archives
private-bin sh,bash,dash,bsdtar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop,lz4,libarchive
private-dev
private-etc passwd,group,localtime



