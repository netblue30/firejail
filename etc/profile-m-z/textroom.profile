# Firejail profile for textroom
# Description: Full Screen text editor heavily inspired by Q10 and JDarkRoom
# This file is overwritten after every install/update
# Persistent local customizations
include textroom.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*
blacklist /usr/libexec

noblacklist ${HOME}/.config/textroom

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-xdg.inc

#mkdir ${HOME}/.config/textroom
#whitelist ${HOME}/.config/textroom
#whitelist ${DOCUMENTS}
#whitelist ${DOWNLOADS}
#whitelist /usr/share/textroom
#include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin textroom
private-cache
private-dev
private-etc
private-tmp

dbus-user filter
dbus-user.talk ca.desrt.dconf
dbus-system none

restrict-namespaces
