# Firejail profile for irssi
# Description: IRC client
# This file is overwritten after every install/update
# Persistent local customizations
include irssi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.irssi

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-write-mnt.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.irssi
whitelist ${HOME}/.irssi

#include whitelist-usr-share-common.inc
#include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noprinters
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
# NOTE: comments here are things that can be improved, if you can spare the time.
##seccomp.drop SYSCALLS (see syscalls.txt)
##seccomp-error-action log (only for debugging seccomp issues)
#shell none
#tracelog
disable-mnt
##private-opt NAME
#private-tmp
##writable-run-user
##writable-var
##writable-var-log

dbus-user none
dbus-system none

# NOTE: almost sure this thing uses perl, but all seems to work without allowing it.

##deterministic-shutdown
##env VAR=VALUE
##join-or-start NAME
#memory-deny-write-execute
##noexec PATH
##read-only ${HOME}
##read-write ${HOME}
restrict-namespaces
