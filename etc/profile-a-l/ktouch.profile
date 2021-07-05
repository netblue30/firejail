# Firejail profile for KTouch
# Description: a typing tutor by KDE
# This file is overwritten after every install/update
# Persistent local customizations
include ktouch.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/ktouch2rc
nodeny  ${HOME}/.local/share/ktouch

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkfile ${HOME}/.config/ktouch2rc
mkdir ${HOME}/.local/share/ktouch
allow  ${HOME}/.config/ktouch2rc
allow  ${HOME}/.local/share/ktouch
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
shell none
tracelog

disable-mnt
private-bin ktouch
private-cache
private-dev
private-etc alternatives,fonts,kde5rc,machine-id
private-tmp

dbus-user none
dbus-system none
