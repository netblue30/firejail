# Firejail profile for tvnamer
# Description: Automatic TV episode file renamer
quiet
# Persistent local customizations
include tvnamer.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}
blacklist /usr/libexec

noblacklist ${HOME}/.config/tvnamer
noblacklist ${VIDEOS}

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-proc.inc
include disable-shell.inc
include disable-x11.inc
include disable-xdg.inc

mkdir ${HOME}/.config/tvnamer
whitelist ${HOME}/.config/tvnamer
whitelist ${DOWNLOADS}
whitelist ${VIDEOS}
include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
tracelog
x11 none

#disable-mnt
private-bin python*,tvnamer
private-cache
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.config/tvnamer
read-write ${DOWNLOADS}
read-write ${VIDEOS}
restrict-namespaces
