# Firejail profile for rymdport
# Description: Encrypted sharing of files, folders, and text between devices
# This file is overwritten after every install/update
# Persistent local customizations
include rymdport.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.config/fyne

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-xdg.inc

#mkdir ${HOME}/.config/fyne
#whitelist ${HOME}/.config/fyne
#whitelist ${DOWNLOADS}
#include whitelist-common.inc
include whitelist-run-common.inc
include whitelist-runuser-common.inc
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

#disable-mnt
private-bin rymdport
private-cache
private-dev
private-etc @network,@tls-ca,@x11
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
