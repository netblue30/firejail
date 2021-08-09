# Firejail profile for bluefish
# Description: Advanced Gtk+ text editor for web and software development
# This file is overwritten after every install/update
# Persistent local customizations
include bluefish.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-var-common.inc

apparmor
caps.drop all
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

private-bin bluefish
private-dev
private-tmp

dbus-user none
dbus-system none
