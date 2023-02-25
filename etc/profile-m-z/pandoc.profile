# Firejail profile for pandoc
# Description: general markup converter
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include pandoc.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}

noblacklist ${DOCUMENTS}

include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
# breaks pdf output
#include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
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
nou2f
novideo
protocol unix
seccomp
seccomp.block-secondary
tracelog
x11 none

disable-mnt
private-cache
private-dev
private-etc texlive,texmf
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
