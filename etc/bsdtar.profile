# Firejail profile for bsdtar
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include bsdtar.local
# Persistent global definitions
include globals.local

include disable-common.inc
# include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

blacklist /tmp/.X11-unix

caps.drop all
hostname bsdtar
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
# noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

# support compressed archives
private-bin sh,bash,bsdcat,bsdcpio,bsdtar,gtar,compress,gzip,lzma,xz,bzip2,lbzip2,lzip,lzop,lz4,libarchive
private-dev
private-etc alternatives,passwd,group,localtime
