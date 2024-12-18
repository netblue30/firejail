# Firejail profile for editorconfiger
# Description: Plain tool to validate and compare .editorconfig files
# This file is overwritten after every install/update
# Persistent local customizations
include editorconfiger.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

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
noprinters
noroot
nosound
notv
nou2f
novideo
seccomp socket
seccomp.block-secondary
tracelog
x11 none

#disable-mnt
private-bin editorconfiger
private-cache
private-dev
private-etc .editorconfig
private-lib
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
