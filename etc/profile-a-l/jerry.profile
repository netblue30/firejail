# Firejail profile for jerry
# Description: Chess GUI
# This file is overwritten after every install/update
# Persistent local customizations
include jerry.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/dkl

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

caps.drop all
machine-id
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

private-bin bash,jerry,sh,stockfish
private-dev
private-etc alternatives,fonts,gtk-2.0,gtk-3.0,ld.so.cache,ld.so.preload
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
