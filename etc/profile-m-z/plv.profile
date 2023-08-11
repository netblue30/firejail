# Firejail profile for plv
# Description: Inspect pacman log files
# This file is overwritten after every install/update
# Persistent local customizations
include plv.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/PacmanLogViewer

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.config/PacmanLogViewer
whitelist ${HOME}/.config/PacmanLogViewer
whitelist /var/log/pacman.log
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
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
noroot
nosound
notv
nou2f
novideo
seccomp
tracelog

disable-mnt
private-bin plv
private-cache
private-dev
private-etc
private-opt none
private-tmp
writable-var-log

dbus-user none
dbus-system none

#memory-deny-write-execute # breaks opening file-chooser
read-only ${HOME}
read-write ${HOME}/.config/PacmanLogViewer
read-only /var/log/pacman.log
restrict-namespaces
