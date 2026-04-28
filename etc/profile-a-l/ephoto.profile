# Firejail profile for ephoto
# Description: A Comprehensive Image Viewer Using EFL
# This file is overwritten after every install/update
# Persistent local customizations
include ephoto.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/efreet
noblacklist ${HOME}/.cache/ephoto
noblacklist ${HOME}/.config/ephoto
noblacklist ${DESKTOP}
noblacklist ${DOWNLOADS}
noblacklist ${PICTURES}

# Allow lua (blacklisted by disable-interpreters.inc)
include allow-lua.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/ephoto
whitelist ${HOME}/.cache/efreet
whitelist ${HOME}/.cache/ephoto
whitelist ${HOME}/.config/ephoto
whitelist ${DESKTOP}
whitelist ${DOWNLOADS}
whitelist ${PICTURES}
whitelist /usr/share/elementary
whitelist /usr/share/ephoto
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
protocol unix
seccomp
seccomp.block-secondary
tracelog

disable-mnt
private-bin efreetd,ephoto
private-cache
private-dev
private-etc @x11
private-tmp

dbus-user none
dbus-system none

memory-deny-write-execute
restrict-namespaces
