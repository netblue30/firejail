# Firejail profile for aria2c
# Description: Download utility that supports HTTP(S), FTP, BitTorrent and Metalink
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/aria2c.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.aria2

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
# private
private-bin aria2c,gzip
private-cache
private-dev
private-etc ca-certificates,ssl
private-lib libreadline.so.*
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
