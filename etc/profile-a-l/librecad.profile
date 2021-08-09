# Firejail profile for librecad
# Persistent local customizations
include librecad.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/LibreCAD
noblacklist ${HOME}/.local/share/LibreCAD

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

whitelist /usr/share/librecad
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
netfilter
nodvd
#nogroups
#noinput
nonewprivs
noroot
notv
#nou2f
novideo
protocol unix,inet,inet6
netfilter
seccomp
shell none
#tracelog

#disable-mnt
private-bin librecad
private-dev
# private-etc cups,drirc,fonts,passwd,xdg
#private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
