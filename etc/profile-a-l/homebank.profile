# Firejail profile for homebank
# Description: Personal finance manager
# This file is overwritten after every install/update
# Persistent local customizations
include homebank.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/homebank

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/homebank
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/homebank
whitelist /usr/share/homebank
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
#net none
netfilter
nodvd
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
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-bin homebank
private-cache
private-dev
private-etc @tls-ca,@x11,mime.types
private-tmp

dbus-user none
dbus-system none

#memory-deny-write-execute
restrict-namespaces
