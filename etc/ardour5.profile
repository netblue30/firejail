# Firejail profile for ardour5
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ardour5.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /run/user/*/bus

noblacklist ${HOME}/.config/ardour4
noblacklist ${HOME}/.config/ardour5
noblacklist ${HOME}/.lv2
noblacklist ${HOME}/.vst

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
net none
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix
seccomp
shell none

#private-bin sh,ardour4,ardour5,ardour5-copy-mixer,ardour5-export,ardour5-fix_bbtppq,grep,sed,ldd,nm
private-dev
#private-etc pulse,X11,alternatives,ardour4,ardour5,fonts
private-tmp

noexec ${HOME}
noexec /tmp
