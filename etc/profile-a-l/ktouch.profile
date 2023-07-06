# Firejail profile for KTouch
# Description: a typing tutor by KDE
# This file is overwritten after every install/update
# Persistent local customizations
include ktouch.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ktouch2rc
noblacklist ${HOME}/.local/share/ktouch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.config/ktouch2rc
mkdir ${HOME}/.local/share/ktouch
whitelist ${HOME}/.config/ktouch2rc
whitelist ${HOME}/.local/share/ktouch
include whitelist-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
net none
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,netlink
seccomp
tracelog

disable-mnt
private-bin ktouch
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
