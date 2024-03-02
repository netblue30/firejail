# Firejail profile for localsend_app
# Description: An open source cross-platform alternative to AirDrop
# This file is overwritten after every install/update
# Persistent local customizations
include localsend_app.local
# Persistent global definitions
include globals.local

blacklist /usr/libexec

noblacklist ${HOME}/.local/share/localsend_app

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
#include disable-xdg.inc

#mkdir ${HOME}/.local/share/localsend_app
#whitelist ${HOME}/.local/share/localsend_app
#whitelist ${DOWNLOADS}
#whitelist /usr/share/localsend_app
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
#no3d
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

private-bin localsend_app
private-cache
private-dev
private-etc @network,@tls-ca
private-tmp

dbus-user none
dbus-system none

read-only ${HOME}
read-write ${HOME}/.local/share/localsend_app
read-write ${DOWNLOADS}
restrict-namespaces
