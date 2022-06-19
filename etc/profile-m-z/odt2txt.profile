# Firejail profile for odt2txt
# Description: Simple converter from OpenDocument Text to plain text
# This file is overwritten after every install/update
# Persistent local customizations
include odt2txt.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

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
tracelog
x11 none

private-bin odt2txt
private-cache
private-dev
private-etc alternatives,ld.so.cache,ld.so.preload
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
