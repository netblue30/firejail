# Firejail profile for default
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/default.local
# Persistent global definitions
include /etc/firejail/globals.local

# generic gui profile
# depending on your usage, you can enable some of the commands below:

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
# include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
#include /etc/firejail/disable-xdg.inc

caps.drop all
# ipc-namespace
netfilter
# no3d
# nodbus
# nodvd
# nogroups
nonewprivs
noroot
# nosound
# notv
# novideo
protocol unix,inet,inet6
seccomp
# shell none

# disable-mnt
# private
# private-bin program
# private-cache
# private-dev
# private-etc none
# private-lib
# private-tmp

# memory-deny-write-execute
# noexec ${HOME}
# noexec /tmp
