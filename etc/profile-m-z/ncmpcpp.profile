# Firejail profile for ncmpcpp
# Description: Featureful ncurses-based MPD client inspired by ncmpc
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include ncmpcpp.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/ncmpcpp
noblacklist ${HOME}/.lyrics
noblacklist /var/lib/mpd

# Allow /bin/sh (blacklisted by disable-shell.inc)
include allow-bin-sh.inc

blacklist ${RUNUSER}
blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-write-mnt.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.config/ncmpcpp
mkdir ${HOME}/.lyrics
whitelist ${HOME}/.config/ncmpcpp
whitelist ${HOME}/.lyrics
whitelist /var/lib/mpd
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

writable-var

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
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
protocol unix,inet,inet6
seccomp
seccomp.block-secondary

disable-mnt
private-bin ncmpcpp,sh
private-cache
private-dev
private-etc terminfo
private-tmp

dbus-user none
dbus-system none

deterministic-shutdown
memory-deny-write-execute
