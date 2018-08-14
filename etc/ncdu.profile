# Firejail profile for ncdu
# Description: Ncurses disk usage viewer
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/ncdu.local
# Persistent global definitions
include /etc/firejail/globals.local

caps.drop all
ipc-namespace
nodbus
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

private-dev
# private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
