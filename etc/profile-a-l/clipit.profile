# Firejail profile for clipit
# Description: Lightweight GTK clipboard manager
# This file is overwritten after every install/update
# Persistent local customizations
include clipit.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/clipit
noblacklist ${HOME}/.local/share/clipit

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/clipit
mkdir ${HOME}/.local/share/clipit
whitelist ${HOME}/.config/clipit
whitelist ${HOME}/.local/share/clipit
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
tracelog

disable-mnt
private-bin clipit,xdotool
private-cache
private-dev
private-lib libxdo.so.*
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
read-only ${HOME}
restrict-namespaces
