# Firejail profile for Musixmatch
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/musixmatch.local
# Persistent global definitions
include /etc/firejail/globals.local

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nogroups 
nosound
notv
novideo
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-dev
private-etc none

noexec ${HOME}
noexec /tmp
