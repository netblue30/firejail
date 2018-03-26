# Firejail profile for ricochet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ricochet.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.local/share/Ricochet

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/.local/share/Ricochet
include /etc/firejail/whitelist-common.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-bin ricochet,tor
private-dev
#private-etc fonts,tor,X11,alternatives

noexec ${HOME}
noexec /tmp
