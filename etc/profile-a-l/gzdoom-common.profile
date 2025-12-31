# Firejail profile for gzdoom-common
# This file is overwritten after every install/update
# Persistent local customizations
include gzdoom-common.local
# Persistent global definitions
# added by caller profile
#include globals.local

noblacklist ${HOME}/.local/share/games/doom

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.local/share/games/doom
whitelist ${HOME}/.local/share/games/doom
whitelist /usr/local/share/doom
whitelist /usr/local/share/games/doom
whitelist /usr/share/doom
whitelist /usr/share/games/doom
whitelist /usr/share/soundfonts
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
nodvd
nogroups
nonewprivs
noprinters
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin bash,dash,gdb,sh,uname,which,xmessage
private-cache
private-dev
private-etc @games,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
