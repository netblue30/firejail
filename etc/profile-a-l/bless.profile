# Firejail profile for bless
# Description: A full featured hexadecimal editor
# This file is overwritten after every install/update
# Persistent local customizations
include bless.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/bless

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

include whitelist-var-common.inc

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

#private-bin bash,bless,mono,sh
private-cache
private-dev
private-etc mono
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
