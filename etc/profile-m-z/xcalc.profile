# Firejail profile for xcalc
# This file is overwritten after every install/update
# Persistent local customizations
include xcalc.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

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

disable-mnt
private
private-bin xcalc
private-dev
private-lib
private-tmp

dbus-user none
dbus-system none
