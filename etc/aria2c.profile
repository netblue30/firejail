# Firejail profile for aria2c
# Description: Download utility that supports HTTP(S), FTP, BitTorrent and Metalink
# This file is overwritten after every install/update
# Persistent local customizations
include aria2c.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.aria2

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
# include disable-xdg.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodbus
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

# disable-mnt
private-bin aria2c,gzip
private-cache
private-dev
private-etc alternatives,ca-certificates,ssl
private-lib libreadline.so.*
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
