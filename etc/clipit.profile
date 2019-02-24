# Firejail profile for clipit
# Description: Lightweight GTK+ clipboard manager
# This file is overwritten after every install/update
# Persistent local customizations
include clipit.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/clipit
noblacklist ${HOME}/.local/share/clipit

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

apparmor
caps.drop all
ipc-namespace
machine-id
net none
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none

disable-mnt
private-cache
private-dev
private-tmp

noexec ${HOME}
noexec /tmp
