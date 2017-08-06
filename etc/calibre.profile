# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/calibre.local

noblacklist ~/.config/calibre
noblacklist ~/.cache/calibre

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

#private-bin
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
